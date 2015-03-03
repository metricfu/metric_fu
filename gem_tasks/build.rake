# encoding: utf-8
require 'rubygems'
require 'digest/sha2'
require 'rake/tasklib'
# require 'bundler/gem_helper'
# Bundler::GemHelper.install_tasks

# Based on https://github.com/bundler/bundler/blob/ec0621d/lib/bundler/gem_helpers.rb
GEM_TASKS = Class.new(Rake::TaskLib) do
  include Rake::DSL if defined? Rake::DSL
  attr_reader :base
  def initialize
    @base = File.expand_path('../..', __FILE__)
    @gemspec_path = File.join(base, 'metric_fu.gemspec')
    @gemspec = Gem::Specification.load(@gemspec_path)
  end

  def install
    built_gem_path = nil

    desc "Build #{built_gem_name} into the pkg directory."
    task 'build' do
      built_gem_path = build_gem
    end

    desc "Build and install #{built_gem_name} into system gems."
    task 'install' => 'build' do
      install_gem(built_gem_path)
    end

    desc 'Creates and commits a SHA512 checksum of the current version built gem'
    task 'checksum' => 'build' do
      add_checksum(built_gem_path)
    end

    desc "Create tag #{version_tag} and build and push #{built_gem_name} to Rubygems"
    task 'release' => 'checksum' do
      release_gem(built_gem_path)
    end

  end

  def build_gem
     file_name = nil
     sh("gem build -V '#{@gemspec_path}'") { |out, code|
       file_name = File.basename(built_gem_path)
       FileUtils.mkdir_p(File.join(base, 'pkg'))
       FileUtils.mv(built_gem_path, 'pkg')
       STDOUT.puts "#{name} #{version} built to pkg/#{file_name}."
     }
     File.join(base, 'pkg', file_name)
  end

  def install_gem(built_gem_path=nil)
    built_gem_path ||= build_gem
    out, _ = sh_with_code("gem install '#{built_gem_path}' --local")
    raise "Couldn't install gem, run `gem install #{built_gem_path}' for more detailed output" unless out[/Successfully installed/]
    STDOUT.puts "#{name} (#{version}) installed."
  end
  # Based on https://github.com/YorickPeterse/ruby-lint/blob/3e946/task/checksum.rake
  def add_checksum(built_gem_path=nil)
    guard_clean
    built_gem_path ||= build_gem
    checksum_file = File.join(checksums, checksum_name)
    File.open(checksum_file, 'w') do |handle|
      handle.write(gem_checksum(built_gem_path))
    end
    sh_with_code("git add #{checksum_file} && git commit -m 'Add checksum for #{built_gem_name}'")
  end

  def checksums
    File.expand_path('../../checksum', __FILE__)
  end

  def checksum_name
    File.basename(built_gem_name) + '.sha512'
  end

  def gem_checksum(built_gem_path)
    checksum(File.read(built_gem_path))
  end

  def checksum(content)
    Digest::SHA512.new.hexdigest(content)
  end

  def release_gem(built_gem_path=nil)
    guard_clean
    built_gem_path ||= build_gem
    add_checksum(built_gem_path) #unless already hashed?
    tag_version { git_push } unless already_tagged?
    rubygem_push(built_gem_path) if gem_push?
  end

  protected

  def rubygem_push(path)
    if Pathname.new("~/.gem/credentials").expand_path.exist?
      sh("gem push '#{path}'")
      STDOUT.puts "Pushed #{name} #{version} to rubygems.org."
    else
      raise "Your rubygems.org credentials aren't set. Run `gem push` to set them."
    end
  end

  def built_gem_path
    Dir[File.join(base, "#{name}-*.gem")].sort_by{|f| File.mtime(f)}.last
  end

  def git_push
    perform_git_push
    perform_git_push ' --tags'
    STDOUT.puts "Pushed git commits and tags."
  end

  def perform_git_push(options = '')
    cmd = "git push #{options}"
    out, code = sh_with_code(cmd)
    raise "Couldn't git push. `#{cmd}' failed with the following output:\n\n#{out}\n" unless code == 0
  end

  def already_tagged?
    if sh('git tag').split(/\n/).include?(version_tag)
      STDOUT.puts "Tag #{version_tag} has already been created."
      true
    end
  end

  def guard_clean
    clean? && committed? or raise("There are files that need to be committed first.")
  end

  def clean?
    sh_with_code("git diff --exit-code")[1] == 0
  end

  def committed?
    sh_with_code("git diff-index --quiet --cached HEAD")[1] == 0
  end

  def tag_version
    sh "git tag -a -m \"Version #{version}\" #{version_tag}"
    STDOUT.puts "Tagged #{version_tag}."
    yield if block_given?
  rescue
    STDERR.puts "Untagging #{version_tag} due to error."
    sh_with_code "git tag -d #{version_tag}"
    raise
  end

  def version
    @gemspec.version
  end

  def version_tag
    "v#{version}"
  end

  def name
    @gemspec.name
  end

  def built_gem_name
    "#{name}-#{version}.gem"
  end

  def sh(cmd, &block)
    out, code = sh_with_code(cmd, &block)
    code == 0 ? out : raise(out.empty? ? "Running `#{cmd}' failed. Run this command directly for more detailed output." : out)
  end

  def sh_with_code(cmd, &block)
    cmd << " 2>&1"
    outbuf = ''
    p cmd
    Dir.chdir(base) {
      outbuf = `#{cmd}`
      if $? == 0
        block.call(outbuf) if block
      end
    }
    [outbuf, $?]
  end

  def gem_push?
    ! %w{n no nil false off 0}.include?(ENV['gem_push'].to_s.downcase)
  end

end.new.install

# Based on https://github.com/YorickPeterse/ruby-lint/blob/3e946e6/task/todo.rake
desc 'Extracts TODO tags and the likes'
task :todo do
  regex = %w{NOTE: FIXME: TODO: THINK: @todo}.join('|')

  sh "ack '#{regex}' lib"
end
