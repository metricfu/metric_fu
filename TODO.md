# TODO list


## Features

* Look into removing rcov and churn, and adding
  * https://github.com/metricfu/code_statistics
  * brakeman https://github.com/metricfu/brakeman
  * cane https://github.com/square/cane
  * laser https://github.com/metricfu/laser
* Add configurable logger to all output streams
* Allow command-line metric_fu to accept parameters, and especially output its version
* Color code flog results with scale from: http://jakescruggs.blogspot.com/2008/08/whats-good-flog-score.html
* Make running metric_fu on metric_fu less embarrassing
* Load all gems at config time so you fail fast if one is missing


## Testing

* Determine how to test metric_fu against codebases that are not metric_fu, to ensure it works on most applications
* <strike>Re-organize test files structure to align with changed structure of library files</strike>
* Remove / Modify Devver code from the generators/hotspots_spec and base/hotspot_analzyer_spec
* <strike>Don't leave around test artifacts such as the folders './foo' and './is set'</strike>

## Bugs / Fixes

* Fix occasional gem install metric_fu failures such as with ripper in Ruby 1.9
* Fork roodi and correct the yaml
* See https://github.com/metricfu/metric_fu/issues/2 about updating gems

## Ruby 1.9 compatibility

* Consider `RUBYOPT='-rpsych'` e.g. from https://github.com/jscruggs/metric_fu/pull/77
* Look into using the sexp_processor for ruby parsing in brakeman https://github.com/presidentbeef/brakeman/blob/cdc85962d589fb37e37ed53333bb0b7bd913e028/lib/ruby_parser/bm_sexp_processor.rb

## Misc

* Determine if CodeIssue is used, else remove it
* Remove references to Ruport from the Devver / Caliper code
* Update the homepage http://metric-fu.rubyforge.org/
* Other intersting libraries to consider:
  * https://github.com/vinibaggio/discover-unused-partials
  * https://github.com/metricfu/heckle
  * https://github.com/metricfu/gauntlet
  * https://github.com/metricfu/repodepot-ruby
  * https://github.com/eladmeidar/rails_indexes
