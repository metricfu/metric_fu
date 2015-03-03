# usage_test = UsageTest.new
# usage_test.test_files(EXAMPLE_FILES)

# puts "SUCCESS!"
# Process.exit! 0
require "open3"

class UsageTest
  CodeBlock = Struct.new(:matchdata) do
    # From kramdown-1.2.0/lib/kramdown/parser/gfm.rb
    FENCED_CODEBLOCK_MATCH = /^(([~`]){3,})\s*?(\w+)?\s*?\n(.*?)^\1\2*\s*?\n/m
    def code
      matchdata[3].strip
    end

    def language
      matchdata[2].strip
    end
    def self.find_code_blocks(markdown)
      markdown.scan(FENCED_CODEBLOCK_MATCH).map do |matchdata|
        new(matchdata)
      end
    end
  end

  def test_files(paths)
    in_test_directory do
      Array(paths).each do |path|
        puts "Testing #{path}"
        CodeBlock.find_code_blocks(File.read(path)).each do |code_block|
          test_code_block!(code_block)
        end
        puts
      end
    end
    puts "SUCCESS!"
    Process.exit! 0
  end

  def test_code_block!(code_block)
    SnippetRunner.new(code_block.code, code_block.language).test!
  end

  private

  def in_test_directory
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) {
        `git init; touch README; git add README; git commit -m 'first'`
        yield
      }
    end
  end
end
SnippetRunner = Struct.new(:code, :language) do
  SystemCommandError = Class.new(StandardError)
  TestResult = Struct.new(:success, :captured_output)

  def test!
    time = Time.now
    test_result = run_code
    mf_debug "#{Time.now - time} seconds"
    if test_result.success
      print "."
    else
      puts "x"
      puts "Red :( language: #{language}, code #{code}, #{test_result.captured_output}"
      Process.exit! 1
    end
  end

  def run_code(test_result = TestResult.new(:no_result, ""))
    test_result.captured_output = case language
                                  when "ruby" then eval_ruby
                                  when "sh"   then run_system_command
                                  else mf_debug "Cannot test language: #{language.inspect}"
                                  end
    test_result.success = true
    test_result
  rescue StandardError => run_error
    test_result.captured_output = exception_message(run_error)
    test_result.success =  false
    test_result
  rescue SystemExit => system_exit
    mf_debug "I am a system exit"
    test_result.captured_output = exception_message(system_exit)
    test_result.success = system_exit.success?
    test_result
  end

  def eval_ruby(fail_on_empty = false)
    capture_output(fail_on_empty) do
      instance_eval(code)
    end
  end

  def run_system_command(_fail_on_empty = true)
    out = ""
    err = ""
    pid = :not_set
    exit_status = :not_set
    Open3.popen3(code) do |_stdin, stdout, stderr, wait_thr|
      out << stdout.read.chomp
      err << stderr.read.chomp
      pid = wait_thr.pid
      exit_status = wait_thr.value
    end
    exit_code = exit_status.exitstatus
    case exit_code
    when 0  then  "Ran with exit status #{exit_code}"
    when (1..Float::INFINITY) then fail SystemCommandError.new("Failed with exit status #{exit_code}. #{err}----#{out}")
    else fail SystemCommandError.new("Execution failed with exit status #{exit_code}. #{err}----#{out}")
    end
  end

  def exception_message(e)
    "#{e.class}\t#{e.message}"
  end

  def capture_output(fail_on_empty)
    exception = nil
    stderr = :not_set
    stdout = :not_set
    MetricFu::Utility.capture_output(STDOUT) do
      stdout =
      MetricFu::Utility.capture_output(STDERR) do
        begin
          stderr = yield
        rescue Exception => e
          exception  = e
        end
      end
    end
    if [nil, "", :not_set].none? { |c| c == stderr }
      mf_debug "Captured STDERR"
      stderr
    elsif [nil, "", :not_set].none? { |c| c == stdout }
      mf_debug "Captured STDOUT"
      stdout
    elsif exception
      mf_debug "Captured Exception"
      raise exception
    else
      mf_debug "Captured Nothing"
      if fail_on_empty
        fail SystemCommandError.new "No output generated or exception caught"
      end
    end
  end
end
