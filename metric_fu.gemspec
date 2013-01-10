# -*- encoding: utf-8 -*-
require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "metric_fu"
  s.platform    = Gem::Platform::RUBY
  s.version     = MetricFu::VERSION
  s.summary     = "A (Ruby 1.8) fistful of code metrics, with awesome templates and graphs"
  s.email       = "github@benjaminfleischer.com"
  s.homepage    = "http://github.com/metricfu/metric_fu"
  s.description = "(Ruby 1.8) Code metrics from Flog, Flay, RCov, Saikuro, Churn, Reek, Roodi, Rails' stats task and Rails Best Practices"
  s.authors     = ["Jake Scruggs", "Sean Soper", "Andre Arko", "Petrik de Heus", "Grant McInnes", "Nick Quaranto", "Édouard Brière", "Carl Youngblood", "Richard Huang", "Dan Mayer", "Benjamin Fleischer"]
  s.rubyforge_project = 'metric_fu'
  s.required_ruby_version     = "~> 1.8.7"
  # s.required_rubygems_version = ">= 1.3.6" per http://docs.rubygems.org/read/chapter/20#required_ruby_version, do not use
  s.files              = `git ls-files`.split($\)
  s.test_files         =  s.files.grep(%r{^(test|spec|features)/})
  s.executables        =  s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.license     = 'MIT'
  {
    "flay"                  => ["= 1.2.1"],
    "metric_fu-roodi"       => [">= 2.2.0"],
    "rails_best_practices"  => ["= 1.3.0"], # needs ripper as dependency
    "rcov"                  => ["~> 0.8"],
    "Saikuro"               => ["= 1.1.0"],
    "reek"                  => ["= 1.2.12"],
    "flog"                  => ["= 2.3.0"],
    "churn"                 => ["= 0.0.25"],
    "sexp_processor"        => ["~> 3.0.3"], # required because of churn, flog, reek 1.2.12, ripper_ruby_parser 0.0.8
    # "ruby_parser"           => ["~> 2.3"], # required because of churn, flog, reek 1.2.12, ripper_ruby_parser 0.0.8
    "coderay"               => [],
    "bluff"                 => [],
    "googlecharts"          => [],
    "activesupport"         => [">= 2.0.0"],
    "ripper"                => ["= 1.0.5"],
    "fattr"                 => ["= 2.2.1"],
    "arrayfields"           => ["= 4.7.4"],
    "map"                   => ["= 6.2.0"]
  }.each do |gem, version|
    if version == []
      s.add_runtime_dependency(gem)
    else
      s.add_runtime_dependency(gem,version)
    end
  end
end
