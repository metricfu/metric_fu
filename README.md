# MetricFu [![Gem Version](https://badge.fury.io/rb/metric_fu.png)](http://badge.fury.io/rb/metric_fu) [![Build Status](https://travis-ci.org/metricfu/metric_fu.png?branch=master)](http://travis-ci.org/metricfu/metric_fu) [![Code Climate](https://codeclimate.com/github/metricfu/metric_fu.png)](https://codeclimate.com/github/metricfu/metric_fu) [![Dependency Status](https://gemnasium.com/metricfu/metric_fu.png)](https://gemnasium.com/metricfu/metric_fu)

## Installation

    gem install metric_fu

If you have trouble installing the gem, try adding metric_fu to your Gemfile. You may also want to file a ticket on the issues page.

See documentation on the rubyforge page for how to customize your metrics. Otherwise, all current information is either in this repo or on the wiki.

## Usage

By default, you can run all metrics from the root of an app with the command `metric_fu -r`

See `metric_fu --help` for more options

## Compatibility

It is currently testing on MRI 1.8.7, 1.9.2, 1.9.3 and 2.0.0.

* The `japgolly-Saikuro` fork and `metric_fu-roodi` fork are a part of an attempt to get metric_fu working in a modern Ruby environment, specifically compatibility with Ruby 1.9 and Bundler.
* rails_best_practices is disabled in ruby 1.8
* metric_fu no longer runs rcov itself. You may still use rcov metrics as documented below

## Documentation

### Configuration

see the .metrics file

### Using Coverage Metrics

in your .metrics file add the below to run pre-generated metrics

    MetricFu::Configuration.run do |config|
      coverage_file = File.expand_path("coverage/rcov/rcov.txt", Dir.pwd)
      config.add_metric(:rcov)
      config.add_graph(:rcov)
      config.configure_metric(:rcov, {:external => coverage_file})
    end

if you want metric_fu to actually run rcov itself (1.8 only), just add

    MetricFu.run_rcov

#### Rcov metrics with Ruby 1.8

To generate the same metrics metric_fu has been generating run from the root of your project before running metric_fu

    RAILS_ENV=test rcov $(ruby -e "puts Dir['{spec,test}/**/*_{spec,test}.rb'].join(' ')") --sort coverage --no-html --text-coverage --no-color --profile --exclude-only '.*' --include-file "\Aapp,\Alib" -Ispec >> coverage/rcov/rcov.txt

#### Simplecov metrics with Ruby 1.9 and 2.0

Add to your Gemfile or otherwise install

    gem 'simplecov'
    # https://github.com/kina/simplecov-rcov-text
    gem 'simplecov-rcov-text'

Modify your spec_helper as per the SimpleCov docs and run your tests before running metric_fu

    #in your spec_helper
    require 'simplecov'
    require 'simplecov-rcov-text'
    SimpleCov.formatter = SimpleCov::Formatter::RcovTextFormatter
    SimpleCov.start
    # SimpleCov.start 'rails'

### Historical

There is some useful-but-out-of-date documentation about configuring metric_fu at http://metric-fu.rubyforge.org/ and a change log in the the HISTORY file.

## Contributions

See the TODO for some ideas

See CONTRIBUTING for how to contribute

## Resources:

This is the official repository for metric_fu.  The original repository by Jake Scruggs at [https://github.com/jscruggs/metric_fu](https://github.com/jscruggs/metric_fu) [has been deprecated.](http://jakescruggs.blogspot.com/2012/08/why-i-abandoned-metricfu.html).

* Github: http://github.com/metricfu/metric_fu
* Issue Tracker: http://github.com/metricfu/metric_fu/issues
* Google Group: http://groups.google.com/group/metric_fu
* Historical Homepage: http://metric-fu.rubyforge.org/

### Original Resources:

* Github: http://github.com/jscruggs/metric_fu
* Issue Tracker: http://github.com/jscruggs/metric_fu/issues
* Jake's Blog: http://jakescruggs.blogspot.com/
