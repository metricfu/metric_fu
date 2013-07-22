# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'metric_fu/version'
require 'metric_fu_requires'

Gem::Specification.new do |s|
  s.name        = "metric_fu"
  s.platform    = Gem::Platform::RUBY
  s.version     = MetricFu::VERSION
  s.summary     = "A fistful of code metrics, with awesome templates and graphs"
  s.email       = "github@benjaminfleischer.com"
  s.homepage    = "https://github.com/metricfu/metric_fu"
  s.description = "Code metrics from Flog, Flay, Saikuro, Churn, Reek, Roodi, Rails' stats task and Rails Best Practices, and optionally RCov"
  s.authors     = ["Jake Scruggs", "Sean Soper", "Andre Arko", "Petrik de Heus", "Grant McInnes", "Nick Quaranto", "Édouard Brière", "Carl Youngblood", "Richard Huang", "Dan Mayer", "Benjamin Fleischer"]
  s.rubyforge_project = 'metric_fu'
  s.required_ruby_version     = ">= 1.8.7"
  s.required_rubygems_version = ">= 1.3.6"
  s.files              = `git ls-files`.split($\)
  s.test_files         =  s.files.grep(%r{^(test|spec|features)/})
  s.default_executable = %q{metric_fu}
  s.executables        =  s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.license     = 'MIT'
  s.has_rdoc = true
  s.extra_rdoc_files = ["HISTORY.md", "CONTRIBUTING.md", "TODO.md", "MIT-LICENSE"]
  s.rdoc_options = ["--main", "README.md"]

  # metric dependencies
  s.add_runtime_dependency 'flay',                  ['= 2.0.1']
  s.add_runtime_dependency 'churn',                 ['= 0.0.28']
  s.add_runtime_dependency 'flog',                  ['= 3.2.2']
  s.add_runtime_dependency 'reek',                  ['= 1.3.1']
  s.add_runtime_dependency 'cane',                  ['= 2.5.2']
    # specifying gem dependencies for
    # flay, churn, flog, reek, and cane
    s.add_runtime_dependency 'ruby_parser',         ['~> 3.0', '>= 3.1.1']
    s.add_runtime_dependency 'sexp_processor',      ['~> 4.0']
      # reek only
      s.add_runtime_dependency 'ruby2ruby',         ['~> 2.0', '>= 2.0.2']
      # cane only
      s.add_runtime_dependency 'parallel',          ['= 0.6.2']
      # required by main, a churn dependency
      s.add_runtime_dependency 'fattr',             ["= 2.2.1"]
      s.add_runtime_dependency 'arrayfields',       ["= 4.7.4"]
      s.add_runtime_dependency 'map',               ["= 6.2.0"]
  s.add_runtime_dependency 'rails_best_practices',  ['= 1.13.2']
  s.add_runtime_dependency 'metric_fu-Saikuro',     ['>= 1.1.1.0']
  s.add_runtime_dependency 'metric_fu-roodi',       ['>= 2.2.1']

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
