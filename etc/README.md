# Scripts

`git clone https://gist.github.com/7209165.git scripts`

Generate list of contributors in descending number of code changes

```sh
ruby scripts/git-rank-contributors.rb > CONTRIBUTORS
```

Generate entity diagram (gotta ensure all the code runs)

```sh
ruby -Ilib -rmetric_fu -rmetric_fu/cli/client -rmetric_fu/metrics/rcov/simplecov_formatter -e "cli = MetricFu::Cli::Client.new; begin; MetricFu.configuration.configure_metric(:rcov){|rcov| rcov.coverage_file = MetricFu.run_path.join('coverage/rcov/rcov.txt'); rcov.enable; rcov.activate}; cli.run; rescue SystemExit; end; ARGV.clear; ARGV.concat(%w[metric_fu MetricFu SimpleCov::Formatter::MetricFu]); load 'scripts/erd.rb'" && mv erd.* etc/
```
