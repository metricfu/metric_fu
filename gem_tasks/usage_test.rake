ROOT_PATH    = File.expand_path("..", File.dirname(__FILE__))
require File.join(ROOT_PATH, 'spec', 'support', 'usage_test')
LIB_PATH     = File.join(ROOT_PATH, 'lib')
BIN_PATH     = File.join(ROOT_PATH, 'bin')
EXAMPLE_FILES = [
  File.join(ROOT_PATH, 'README.md'),
  File.join(ROOT_PATH, 'DEV.md')
]
task "load_path" do
  $LOAD_PATH.unshift(LIB_PATH)
  $VERBOSE = nil
  ENV['PATH'] = "#{BIN_PATH}:#{ENV['PATH']}"
  ENV['CC_BUILD_ARTIFACTS'] = 'turn_off_browser_opening'
end
desc "Test that documentation usage works"
task "usage_test" => %w[load_path] do
  usage_test = UsageTest.new
  usage_test.test_files(EXAMPLE_FILES)
end
