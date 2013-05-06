# TODO list

* Keep HISTORY.md in master up to date

Items in each category are in generally order of decreasing priority.
The categories themselves are not in any priority order.

Also see [CONTRIBUTING](./CONTRIBUTING.md)

## Features

* Make it easier to whitelist metrics when running from the commanline (cli)
* Be able to specify folders to run against rather than just app and lib
* Be able to run metric tools from metric_fu without shelling out
* Allow the coverage task to specify the command it runs plus any flags (see bundler/capistrano options)
* Add configurable logger to all output streams
* Load all gems at config time so you fail fast if one is missing
* Color code flog results with scale from: http://jakescruggs.blogspot.com/2008/08/whats-good-flog-score.html
* Make the template pages prettier (hold off until [61](https://github.com/metricfu/metric_fu/pull/61) is merged)
* Be able to generate historical metrics for eg gem releases (tagged with appropriate date)

## Testing

* Test against a rails app, see [yui-rails](https://github.com/nextmat/yui-rails/tree/master/test/dummy)
* Determine how to test metric_fu against codebases that are not metric_fu, to ensure it works on most applications
  * This is especially true for rails applications
* Remove / Modify Devver code from the generators/hotspots_spec and base/hotspot_analzyer_spec
* Add tests
* Remove useless tests

## Bugs / Fixes

* See issues

## Misc

### Improvements

* Change  how config works to not metaprogrammatically create so many
instance variables and accessors
* Clarify the execution path and what a metric's api should be, (repeat for templates and graphs)
* Change MetricFu.report.add(metric) to e.g. MetricFu.generate_report(metric) to make clear that this actually runs the tool
* Clarify hotspot weighting
* Update the wiki with use cases
* Review how metric_fu uses each tools to generate metrics, e.g. by shelling out commands, rake task, modifying the output, etc.
* Understand and explain s-expressions and how they're used (or should be ) here https://github.com/metricfu/metric_fu/blob/master/lib/metric_fu/data_structures/line_numbers.rb (via the ruby parser ) maybe see [ripper-tags](https://github.com/tmm1/ripper-tags)
* Remove dead code
* Determine if CodeIssue is used, else remove it
* Remove references to Ruport from the Devver / Caliper code
* Understand and explain how each metric can be used
* Improve metric_fu code metrics
* Refactor the hotspots code
* Is there any reason not to remove the Manifest.txt?

### Documentation

* Get the rdoc (or yard) published
* Add more inline documentation
* See other documentation code for examples to improve ours:
  * https://github.com/charliesome/better_errors/blob/master/CONTRIBUTING.md
  * https://github.com/charliesome/better_errors/blob/master/README.md

### Other

* Look into issues for the tools metric_fu uses
* Look into other tools that might work well
* Update contributing or issue guidlines
* Suggest commit message guidelines
* [Update the homepage](https://github.com/metricfu/metricfu.github.com)

## Future Thoughts

* Look into how to manage plugins or otherwise load abritrary metrics
  * [Hoe](https://github.com/seattlerb/hoe/blob/master/lib/hoe.rb#L301)
  * CLI [Flog](https://github.com/seattlerb/flog/blob/master/lib/flog_cli.rb) Plugins [Flog](https://github.com/seattlerb/flog/blob/master/lib/flog_cli.rb#L34)
* Look into adding
  * https://github.com/metricfu/code_statistics
  * brakeman https://github.com/metricfu/brakeman
  * laser https://github.com/metricfu/laser
* Other intersting libraries to consider:
  * https://gist.github.com/4562865 for generating Flog on ERB templates by jamesmartin
  * https://github.com/chad/turbulence churn and complexity (flog)
  * https://github.com/vinibaggio/discover-unused-partials
  * https://github.com/metricfu/heckle (test mutation)
  * https://github.com/mbj/mutant (test mutation)
  * https://github.com/metricfu/gauntlet
  * https://github.com/metricfu/repodepot-ruby https://twitter.com/jakescruggs/status/70521977303076865
  * https://github.com/eladmeidar/rails_indexes
  * https://github.com/trptcolin/consistency_fail 
  * https://github.com/thoughtbot/appraisal
  * https://github.com/jenkinsci/rubymetrics-plugin
  * https://github.com/holman/hopper
  * https://github.com/eric/metriks

## Useful Links

### Ruby Guides

* https://github.com/cwgem/RubyGuide
* https://github.com/bbatsov/rubocop
* https://github.com/bbatsov/ruby-style-guide
* https://github.com/bbatsov/rails-style-guide
* [Learning resources](http://www.benjaminfleischer.com/learning/ruby/tutorials.html) [Source](https://github.com/bf4/learning/tree/gh-pages)

### Perf tools

* https://github.com/tmm1/perftools.rb
* https://twitter.com/mperham/status/311332913641840641
