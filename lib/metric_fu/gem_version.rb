# coding: utf-8
require "rubygems"
module MetricFu
  class GemVersion
    # regexp from https://github.com/gemnasium/gemnasium-parser/blob/807d7ccc/lib/gemnasium/parser/patterns.rb#L11
    #   under MIT License
    GEM_NAME = /[a-zA-Z0-9\-_\.]+/
    QUOTED_GEM_NAME = /(?:(?<gq>["'])(?<name>#{GEM_NAME})\k<gq>|%q<(?<name>#{GEM_NAME})>)/
    MATCHER = /(?:=|!=|>|<|>=|<=|~>)/
    VERSION = /[0-9]+(?:\.[a-zA-Z0-9]+)*/
    REQUIREMENT = /[ \t]*(?:#{MATCHER}[ \t]*)?#{VERSION}[ \t]*/
    REQUIREMENT_LIST = /(?<qr1>["'])(?<req1>#{REQUIREMENT})\k<qr1>(?:[ \t]*,[ \t]*(?<qr2>["'])(?<req2>#{REQUIREMENT})\k<qr2>)?/
    REQUIREMENTS = /(?:#{REQUIREMENT_LIST}|\[[ \t]*#{REQUIREMENT_LIST}[ \t]*\])/
    COMMENT = /(#[^\n]*)?/
    ADD_DEPENDENCY_CALL = /^[ \t]*\w+\.add(?<type>_runtime|_development)?_dependency\(?[ \t]*#{QUOTED_GEM_NAME}(?:[ \t]*,[ \t]*#{REQUIREMENTS})?[ \t]*\)?[ \t]*#{COMMENT}$/

    def initialize
      @gem_spec = File.open(gemspec, "rb") { |f| f.readlines }
    end

    def gemspec
      File.join(MetricFu.root_dir, "metric_fu.gemspec")
    end

    def new_dependency(name, version)
      Gem::Dependency.new(name, version, :runtime)
    end

    def gem_runtime_dependencies
      @gem_runtime_dependencies ||=
        begin
          @gem_spec.grep(/add_dependency|add_runtime/).map do |line|
            match = line.match(ADD_DEPENDENCY_CALL)
            name = match["name"].downcase.sub("metric_fu-", "")
            version = [match["req1"], match["req2"]].compact
            new_dependency(name, version)
          end.compact << new_dependency("rcov", ["~> 0.8"])
        end
    end

    def for(name)
      name.downcase!
      dep = gem_runtime_dependencies.find(unknown_dependency(name)) do |gem_dep|
        gem_dep.name == name
      end

      dep.requirements_list
    end

    def unknown_dependency(name)
      -> { new_dependency(name, [">= 0"]) }
    end

    RESOLVER = new
    def self.for(name)
      RESOLVER.for(name).dup
    end

    def self.dependencies
      RESOLVER.gem_runtime_dependencies.dup
    end

    def self.activated_gems
      if Gem::Specification.respond_to?(:stubs)
        Gem::Specification.stubs
      else
        Gem.loaded_specs.values
      end.select(&:activated?)
    end

    def self.activated_version(name)
      activated_gems.find do |gem|
        return gem.version.version if gem.name == name
      end
    end

    def self.dependency_summary(gem_dep)
      name = gem_dep.name
      version = activated_version(gem_dep.name) || gem_dep.requirements_list
      {
        "name" => name,
        "version" => version,
      }
    end

    def self.dependencies_summary
      dependencies.map do |gem_dep|
        dependency_summary(gem_dep)
      end
    end
  end
end
