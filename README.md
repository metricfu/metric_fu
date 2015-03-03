# MetricFu [![Gem Version](https://badge.fury.io/rb/metric_fu.png)](http://badge.fury.io/rb/metric_fu) [![Build Status](https://travis-ci.org/metricfu/metric_fu.png?branch=master)](http://travis-ci.org/metricfu/metric_fu)

[![Code Climate](https://codeclimate.com/github/metricfu/metric_fu.png)](https://codeclimate.com/github/metricfu/metric_fu) [![Inline docs](http://inch-ci.org/github/metricfu/metric_fu.png)](http://inch-ci.org/github/metricfu/metric_fu) [![Dependency Status](https://gemnasium.com/metricfu/metric_fu.png)](https://gemnasium.com/metricfu/metric_fu)

[Rdoc](http://rdoc.info/github/metricfu/metric_fu/)

## Installation

    gem install metric_fu

If you have trouble installing the gem
- try adding metric_fu to your Gemfile and bundling.
- file a ticket on the issues page.

MetricFu is [cryptographically signed](http://guides.rubygems.org/security/).
To be sure the gem you install hasn't been tampered with:
- Add my public key (if you haven't already) as a trusted certificate `gem cert --add <(curl -Ls https://raw.github.com/metricfu/metric_fu/master/certs/bf4.pem)`
- `gem install metric_fu -P MediumSecurity`

The MediumSecurity trust profile will verify signed gems, but allow the installation of unsigned dependencies.

This is necessary because not all of MetricFu's dependencies are signed, so we cannot use HighSecurity.

## Usage

From your application root. Running via Rake is still supported.

```sh
metric_fu
```

See:
- `metric_fu --help` for more options
- Documentation and Compatibility below
- There is also a [wiki page of user-maintained usage information](https://github.com/metricfu/metric_fu/wiki#usage)

## Contact

*Code and Bug Reports*

* [Issue Tracker](http://github.com/metricfu/metric_fu/issues)
  * See [CONTRIBUTING](https://github.com/metricfu/metric_fu/blob/master/CONTRIBUTING.md) for how to contribute

*Questions, Problems, Suggestions, etc.*

* [Google Group](https://groups.google.com/forum/#!forum/metric_fu)

## Documentation


MetricFu will attempt to load configuration data from a
`.metrics` file, if present in your repository root.

```ruby
MetricFu.report_name # by default, your directory base name
MetricFu.report_name = 'Something Convenient'
```

### Example Configuration

```ruby
# To configure individual metrics...
MetricFu::Configuration.run do |config|
  config.configure_metric(:cane) do |cane|
    cane.enabled = true
    cane.abc_max = 15
    cane.line_length = 80
    cane.no_doc = 'y'
    cane.no_readme = 'y'
  end
end

# Or, alternative format
MetricFu.configuration.configure_metric(:churn) do |churn|
  churn.enabled = true
  churn.ignore_files = 'HISTORY.md, TODO.md'
  churn.start_date = '6 months ago'
end

# Or, to (re)configure all metrics
MetricFu.configuration.configure_metrics.each do |metric|
  if [:churn, :flay, :flog].include?(metric.name)
    metric.enabled = true
  else
    metric.enabled = false
  end
end
```

## Formatters

### Built-in Formatters

By default, metric_fu will use the built-in html formatter to generate HTML reports for each metric with pretty graphs.

These reports are generated in metric_fu's output directory (`tmp/metric_fu/output`) by default. You can customize the output directory by specifying an out directory at the command line
using a relative path:

```sh
metric_fu --out custom_directory    # outputs to tmp/metric_fu/custom_directory
```

or a full path:

```sh
metric_fu --out $HOME/tmp/metrics      # outputs to $HOME/tmp/metrics
```

You can specify a different formatter at the command line by referencing a built-in formatter or providing the fully-qualified name of a custom formatter.


```sh
metric_fu --format yaml --out custom_report.yml
```

Or in Ruby, such as in your `.metrics`

```ruby
# Specify multiple formatters
# The second argument, the output file, is optional
MetricFu::Configuration.run do |config|
  config.configure_formatter(:html)
  config.configure_formatter(:yaml, "customreport.yml")
  config.configure_formatter(:yaml)
end
```

### Custom Formatters

You can customize metric_fu's output format with a custom formatter.

To create a custom formatter, you simply need to create a class
that takes an options hash and responds to one or more notifications:

```ruby
class MyCustomFormatter
  def initialize(opts={}); end    # metric_fu will pass in an output param if provided.

  # Should include one or more of...
  def start; end           # Sent before metric_fu starts metric measurements.
  def start_metric(metric); end   # Sent before individual metric is measured.
  def finish_metric(metric); end   # Sent after individual metric measurement is complete.
  def finish; end           # Sent after metric_fu has completed all measurements.
  def display_results; end     # Used to open results in browser, etc.
end
```

Then

```shell
metric_fu --format MyCustomFormatter
```

See [lib/metric_fu/formatter/](lib/metric_fu/formatter/) for examples.

MetricFu will attempt to require a custom formatter by
fully qualified name based on ruby search path. So if you include a custom
formatter as a gem in your Gemfile, you should be able to use it out of the box.
But you may find in certain cases that you need to add a require to
your .metrics configuration file.

For instance, to require a formatter in your app's lib directory `require './lib/my_custom_formatter.rb'`

##  Configure Graph Engine

By default, MetricFu uses the Bluff (JavaScript) graph engine.

```ruby
MetricFu.configuration.configure_graph_engine(:bluff)
```

But it you may also use the [Highcharts JS library](http://shop.highsoft.com/highcharts.html)

```ruby
MetricFu.configuration.configure_graph_engine(:highcharts)
```

Notice: There was previously a :gchart option.
It was not properly deprecated in the 4.x series.

### Using Coverage Metrics

in your .metrics file add the below to run pre-generated metrics

```ruby
MetricFu::Configuration.run do |config|
  config.configure_metric(:rcov) do |rcov|
    rcov.coverage_file = MetricFu.run_path.join("coverage/rcov/rcov.txt")
    rcov.enable
    rcov.activate
  end
end
```

If you want metric_fu to actually run rcov itself (1.8 only), don't specify an external file to read from

#### Rcov metrics with Ruby 1.8

To generate the same metrics metric_fu has been generating run from the root of your project before running metric_fu

```shell
RAILS_ENV=test rcov $(ruby -e "puts Dir['{spec,test}/**/*_{spec,test}.rb'].join(' ')") --sort coverage --no-html --text-coverage --no-color --profile --exclude-only '.*' --include-file "\Aapp,\Alib" -Ispec > coverage/rcov/rcov.txt
```

#### Simplecov metrics with Ruby 1.9 and 2.0

Add to your Gemfile or otherwise install

```ruby
gem 'simplecov'
```

Modify your [spec_helper](https://github.com/metricfu/metric_fu/blob/master/spec/spec_helper.rb) as per the SimpleCov docs and run your tests before running metric_fu

```ruby
#in your spec_helper
require 'simplecov'
require 'metric_fu/metrics/rcov/simplecov_formatter'
SimpleCov.formatter = SimpleCov::Formatter::MetricFu
# or
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::MetricFu
  ]
SimpleCov.start
```

Additionally, the `coverage_file` path must be specified as above
and must exist.

## Common problems / debugging

- ['ArgumentError; message invalid byte sequence in US-ASCII'](https://github.com/metricfu/metric_fu/issues/215) may be caused by having a default external encoding that is not UTF-8. You can see this in the output of `metric_fu --debug`
  - OSX: Ensure you have set `LANG=en_US.UTF-8` and `LC_ALL=en_US.UTF-8`.  You can add these to your `~/.profile`.

## Compatibility

* It is currently testing on MRI (>= 1.9.3), JRuby (19 mode), and Rubinius (19 mode). Ruby 1.8 is no longer supported.

* For 1.8.7 support, see version 3.0.0 for partial support, or 2.1.3.7.18.1 (where [Semantic Versioning](http://semver.org/) goes to die)

* MetricFu no longer runs any of the analyzed code. For code coverage, you may use a formatter as documented above

* The Cane, Flog, and Rails Best Practices metrics are disabled when Ripper is not available

### Historical

There is some useful-but-out-of-date documentation about configuring metric_fu at http://metricfu.github.io/metric_fu and a change log in the the HISTORY file.

## Resources:

This is the official repository for metric_fu.  The original repository by Jake Scruggs at [https://github.com/jscruggs/metric_fu](https://github.com/jscruggs/metric_fu) has been deprecated.

* [Official Repository](http://github.com/metricfu/metric_fu)
* [Outdated Homepage](http://metricfu.github.io/metric_fu/)
* [List of code tools](https://github.com/metricfu/metric_fu/wiki/Code-Tools)
* [Roadmap](https://github.com/metricfu/metric_fu/wiki/Roadmap)

### Metrics

* [Cane](https://rubygems.org/gems/cane), [Source](http://github.com/square/cane)
* [Churn](https://rubygems.org/gems/churn), [Source](http://github.com/danmayer/churn)
* [Flog](https://rubygems.org/gems/flog), [Source](https://github.com/seattlerb/flog)
* [Flay](https://rubygems.org/gems/flay), [Source](https://github.com/seattlerb/flay)
* [Reek](https://rubygems.org/gems/reek) [Source](https://github.com/troessner/reek)
* [Roodi](https://rubygems.org/gems/roodi), [Source](https://github.com/roodi/roodi)
* [Saikuro](https://rubygems.org/gems/metric_fu-Saikuro), [Source](https://github.com/metricfu/Saikuro)
* [Code Statistics](https://rubygems.org/gems/code_metrics), [Source](https://github.com/bf4/code_metrics)
* Rails-only
  * [Rails Best Practices](https://rubygems.org/gems/rails_best_practices), [Source](https://github.com/railsbp/rails_best_practices)
* Test Coverage
  * 1.9: [SimpleCov](http://rubygems.org/gems/simplecov) and SimpleCov::Formatter::MetricFu
  * 1.8: [Rcov](http://rubygems.org/gems/rcov)
* Hotspots (a meta-metric of the above)


### Original Resources:

* Github: http://github.com/jscruggs/metric_fu
* Issue Tracker: http://github.com/jscruggs/metric_fu/issues
* Historical Homepage: http://metric-fu.rubyforge.org/
* Jake's Blog: http://jakescruggs.blogspot.com/
* Jake's Post about stepping down: http://jakescruggs.blogspot.com/2012/08/why-i-abandoned-metricfu.html


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/metricfu/metric_fu/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
