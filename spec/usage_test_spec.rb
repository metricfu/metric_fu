describe "usage test" do
  ROOT_PATH    = File.expand_path("..", File.dirname(__FILE__))
  require File.join(ROOT_PATH, "spec/support/usage_test")

  it "extracts fenced code blocks, identifying the code and language" do
    ruby_code = "puts 'This is ruby'"
    shell_code = %(ruby -e "puts 'This is shell'")
    ruby_block, shell_block = UsageTest::CodeBlock.find_code_blocks(<<-README
This is not code

```ruby
#{ruby_code}
```

Nope. Not code.

```sh
#{shell_code}
```

Not code, either.
README
)
    expect(ruby_block.language).to eq("ruby")
    expect(ruby_block.code).to eq(ruby_code)

    expect(shell_block.language).to eq("sh")
    expect(shell_block.code).to eq(shell_code)
  end

  context "evaluating ruby code" do
    specify "succeeds when the code runs without errors" do
      code = "1 + 1"
      test_result = SnippetRunner.new(code, "ruby").run_code
      expect(test_result.captured_output).to eq(2)
      expect(test_result.success).to eq(true)
    end
    specify "fails when the code raises a standard error" do
      code = "fail NameError.new('no name')"
      test_result = SnippetRunner.new(code, "ruby").run_code
      expect(test_result.captured_output).to match("NameError")
      expect(test_result.captured_output).to match("no name")
      expect(test_result.success).to eq(false)
    end
    specify "succeeds when the code exits with a zero exit status" do
      code = "puts 1 + 1; exit 0"
      test_result = SnippetRunner.new(code, "ruby").run_code
      expect(test_result.captured_output).to match("SystemExit")
      expect(test_result.success).to eq(true)
    end
    specify "fails when the code exits with a non-zero exit status" do
      code = "puts 1 + 1; exit 1"
      test_result = SnippetRunner.new(code, "ruby").run_code
      expect(test_result.captured_output).to match("SystemExit")
      expect(test_result.success).to eq(false)
    end
  end
  context "evaluating shell commands" do
    specify "succeeds when the command runs without errors" do
      code = "which ruby"
      test_result = SnippetRunner.new(code, "sh").run_code
      expect(test_result.captured_output).to match("exit status 0")
      expect(test_result.success).to eq(true)
    end
    specify "fails when the command runs with an error" do
      code = "sandwhich_fu ruby"
      test_result = SnippetRunner.new(code, "sh").run_code
      expect(test_result.captured_output).to match(failed_command_error)
      expect(test_result.success).to eq(false)
    end
    specify "succeeds when the code exits with a zero exit status" do
      code = "sh '#{fixtures_path.join('exit0.sh').to_path}'"
      test_result = SnippetRunner.new(code, "sh").run_code
      expect(test_result.captured_output).to match("exit status 0")
      expect(test_result.success).to eq(true)
    end
    specify "fails when the code exits with a non-zero exit status" do
      code = "sh '#{fixtures_path.join('exit1.sh').to_path}'"
      test_result = SnippetRunner.new(code, "sh").run_code
      expect(test_result.captured_output).to match("exit status 1")
      expect(test_result.success).to eq(false)
    end
  end

  def failed_command_error
    defined?(JRUBY_VERSION) ? "IOError" : "Errno::ENOENT"
  end

  def fixtures_path
    fixtures_dir = File.join(File.expand_path("..", File.dirname(__FILE__)), "spec", "fixtures")
    Pathname(fixtures_dir)
  end
end
