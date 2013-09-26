# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'metric_fu/version'

Gem::Specification.new do |s|
  s.name        = "metric_fu"
  s.homepage    = "https://github.com/metricfu/metric_fu"
  s.summary     = "A fistful of code metrics, with awesome templates and graphs"
  s.description = "Code metrics from Flog, Flay, Saikuro, Churn, Reek, Roodi, Code Statistics, and Rails Best Practices. (and optionally RCov)"
  s.email       = "github@benjaminfleischer.com"
  s.authors     = File.readlines('AUTHORS').map(&:strip)

  s.rubyforge_project           = 'metric_fu'
  s.license                     = 'MIT'
  s.platform                    = Gem::Platform::RUBY
  s.version                     = MetricFu::VERSION
  s.required_ruby_version       = ">= 1.9.0"
  s.required_rubygems_version   = ">= 1.3.6"

  s.files                       = `git ls-files`.split($\)
  s.test_files                  =  s.files.grep(%r{^(test|spec|features)/})
  s.default_executable          = %q{metric_fu}
  s.executables                 =  s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.require_paths               = ["lib"]

  s.has_rdoc                    = true
  s.extra_rdoc_files            = ["HISTORY.md", "CONTRIBUTING.md", "TODO.md", "MIT-LICENSE"]
  s.rdoc_options                = ["--main", "README.md"]

  # metric dependencies
  s.add_runtime_dependency 'flay',                  ['>= 2.0.1',  '~> 2.1']
  s.add_runtime_dependency 'churn',                 ['~> 0.0.28']
  s.add_runtime_dependency 'flog',                  ['>= 4.1.1',  '~> 4.1']
  s.add_runtime_dependency 'reek',                  ['>= 1.3.3',  '~> 1.3']
  s.add_runtime_dependency 'cane',                  ['>= 2.5.2',  '~> 2.5']
  s.add_runtime_dependency 'rails_best_practices',  ['>= 1.14.4', '~> 1.14']
  s.add_runtime_dependency 'metric_fu-Saikuro',     ['>= 1.1.1.0']
  s.add_runtime_dependency 'roodi',                 ['~> 3.1']
  s.add_runtime_dependency 'code_metrics',          ['~> 0.1']

  # other dependencies
  # ruby version identification
  s.add_runtime_dependency 'redcard'
  # syntax highlighting
  s.add_runtime_dependency 'coderay'
  # default graphing libraries
  s.add_runtime_dependency 'bluff'
  # to_json support
  s.add_runtime_dependency 'multi_json'

end
