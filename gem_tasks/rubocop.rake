if ENV["FULL_BUILD"] != "true" # skip on Travis
  require "rubocop/rake_task"
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.patterns = ["lib", "spec"]
    task.formatters = ["progress"]
    task.options = ["--display-cop-names"]
    task.fail_on_error = false
    task.verbose = false
  end
end
