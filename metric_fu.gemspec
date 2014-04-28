# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'metric_fu/version'

Gem::Specification.new do |s|
  s.name        = "metric_fu"
  s.homepage    = "https://github.com/metricfu/metric_fu"
  s.summary     = "A fistful of code metrics, with awesome templates and graphs"
  s.description = "Code metrics from Flog, Flay, Saikuro, Churn, Reek, Roodi, Code Statistics, and Rails Best Practices. (and optionally RCov)"
  s.email       = "github@benjaminfleischer.com"
  author_file   = File.expand_path('AUTHORS', File.dirname(__FILE__))
  s.authors     = File.readlines(author_file, :encoding => Encoding::UTF_8).map(&:strip)

  # used with gem i metric_fu -P HighSecurity
  s.cert_chain  = ['certs/bf4.pem']
  # Sign gem when evaluating spec with `gem` command
  #  unless ENV has set a SKIP_GEM_SIGNING
  if ($0 =~ /gem\z/) and not ENV.include?('SKIP_GEM_SIGNING')
    s.signing_key = File.join(Gem.user_home, '.ssh', 'gem-private_key.pem')
  end

  s.rubyforge_project           = 'metric_fu'
  s.license                     = 'MIT'
  s.platform                    = Gem::Platform::RUBY
  s.version                     = MetricFu::VERSION
  s.required_ruby_version       = ">= 1.9.0"
  s.required_rubygems_version   = ">= 1.3.6"

    tracked_files = `git ls-files`.split($\)
    excluded_dirs = %r{\Aetc}
    files         = tracked_files.reject{|file| file[excluded_dirs] }
    test_files    = files.grep(%r{^(test|spec|features)/})
    executables   = files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.files                       = files
  s.test_files                  = test_files
  s.executables                 = executables
  s.default_executable          = %q{metric_fu}
  s.require_paths               = ["lib"]

  s.has_rdoc                    = true
  s.extra_rdoc_files            = ["HISTORY.md", "CONTRIBUTING.md", "TODO.md", "MIT-LICENSE"]
  s.rdoc_options                = ["--main", "README.md"]

  # metric dependencies
  s.add_runtime_dependency 'flay',                  ['>= 2.0.1',  '~> 2.1']
  s.add_runtime_dependency 'churn',                 ['~> 0.0.35']
  s.add_runtime_dependency 'flog',                  ['>= 4.1.1',  '~> 4.1']
  s.add_runtime_dependency 'reek',                  ['>= 1.3.4',  '~> 1.3']
  s.add_runtime_dependency 'cane',                  ['>= 2.5.2',  '~> 2.5']
  s.add_runtime_dependency 'rails_best_practices',  ['>= 1.14.3', '~> 1.14']
  s.add_runtime_dependency 'metric_fu-Saikuro',     ['>= 1.1.3',  '~> 1.1']
  s.add_runtime_dependency 'roodi',                 ['~> 3.1']
  s.add_runtime_dependency 'code_metrics',          ['~> 0.1']

  # other dependencies
  # ruby version identification
  s.add_runtime_dependency 'redcard'
  # syntax highlighting
  s.add_runtime_dependency 'coderay'
  # to_json support
  s.add_runtime_dependency 'multi_json'
  # open browser support
  s.add_runtime_dependency 'launchy', '~> 2.0'

  # temporary filesystem to act on
  s.add_development_dependency   'test_construct'
  # ensure we have a JSON parser
  s.add_development_dependency   'json'
  s.add_development_dependency   'simplecov'

end
