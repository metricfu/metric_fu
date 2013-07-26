Changes are below categorized as `Features, Fixes, or Misc`.

Each change should fall into categories that would affect whether the release is major (breaking changes), minor (new behavior), or patch (bug fix). See [semver](http://semver.org/) and [pessimistic versioning](http://docs.rubygems.org/read/chapter/16#page74)

As such, a _Feature_ would map to either major or minor. A _bug fix_ to a patch.  And _misc_ is either minor or patch, the difference being kind of fuzzy for the purposes of history.  Adding tests would be patch level.

### Master
* Features
  * Allow customization of reporting results using formatters (Robin Curry #94)
* Fixes
  * obey --no-open option (Chris Mason)
  * Don't run the hotspots metric if it has been disabled (Chris Mason)
  * No longer crashes when rake stats outputs blank lines (Benjamin Fleischer #103, #24)
  * Run saikuro metrics the same way as the other metrics (Martin Gotink #100)
  * Add missing Cane Google Chart Grapher (Benjamin Fleischer)
  * Fix wrong arguments to display_location, split off line numbers from paths (Benjamin Fleischer #88)
  * Remove line numbers from direct file link so the browser can open it (Benjamin Fleischer #82)
  * Make the run specs work without the need to shell out (Robin Curry)
* Misc
  * metric_fu runs with the -r option by default (Chris Mason #69)
  * Switch to metric_fu-Saikuro gem (Benjamin Fleischer)
  * Reduce Grapher code duplication (Benjamin Fleischer #89)

### MetricFu 4.2.1 / 2013-05-23

* Fixes
  * Remove ActiveSupport dependencies (Benjamin Fleischer #79)
    * Add MultiJson to ensure JSON support in rbx and jruby (Benjamin Fleischer)
* Misc
  * Improve STDOUT to show which metric is running but hide the details by default

### MetricFu 4.2.0 / 2013-05-20

* Features
  * Allow setting of the --continue flag with flog (Eric Wollesen)
*Fixes
  * Allow the 2.0.x point releases (Benjamin Fleischer #75)
* Misc
  * Make Location and AnalyzedProblems code more confident (Avdi Grimm)

### MetricFu 4.1.3 / 2013-05-13

* Features
  * Tests now pass in JRuby and Rubinius! (Benjamin Fleischer)
* Fixes
  * Line numbers now display and link properly in annotated code (Benjamin Fleischer)
  * No longer remove historical metrics when testing metric_fu
  * Churn metric handler won't crash when no source control found (Dan Mayer)
* Misc (Benjamin Fleischer)
  * Removed StandardTemplate, had no additional value and needed to be maintained
  * Removed most template references to specific metrics

### MetricFu 4.1.2 / 2013-04-17

* Fixes
  * No longer load rake when running from the command line (Benjamin Fleischer)
  * Disable rails_best_practices in non-MRI rubies as it requires ripper (Benjamin Fleischer)
  * Ensure metric executables use the same version the gemfile requires (Benjamin Fleischer)

### MetricFu 4.1.1 / 2013-04-16

* Fixes
  * Fix Syck warning in Ruby > 1.9 (Todd A. Jacobs #58, Benjamin Fleischer)
  * Cane parser doesn't blow up when no output returned (Guilherme Souza #55)
  * Fix typo in readme (Paul Elliott #52)
  * Disable Flog and Cane in non-MRI rubies, as they require ripper (Benjamin Fleischer)
* Refactor hotspots and graph code to live in its own metric (Benjamin Fleischer #54, #60)
* Use RedCard gem to determine ruby version and ruby engine
* Fix Gemfile ssl source warning

### MetricFu 4.1.0 / 2013-03-06

* Fix crash in cane when missing readme (Sathish, pull request #51)
* Prevent future cane failures on unexpected violations (Sathish, pull request #51)

### MetricFu 4.0.0 / 2013-03-05

* Adding cane metrics (Sathish, pull request #49)
  * Not yet included in hotspots
  * *Removed ruby 1.8 support*

### MetricFu 3.0.1 / 2013-03-01

* Fixed typo in Flay generator (Sathish, pull request #47)

### MetricFu 3.0.0 / 2013-02-07

#### Features

* Included metrics: churn, flay, flog, roodi, saikuro, reek, 'coverage', rails stats, rails_best_practices, hotspots.
* Works with ruby 1.9 syntax.
* Can be configured just like metrical, with a .metrics file.
* Add commandline behavior to `metric_fu`. Try `metric_fu --help`.
* Does not require rake to run. Can be run directly from the commandline.
* Is tested to run on rbx-19 and jruby-19 in addition to cruby-19 and cruby-18.
* churn options include :minimum-churn-count and :start-date, see https://github.com/metricfu/metric_fu/blob/master/lib/metric_fu/metrics/churn/init.rb
* Installation and running it have less dependency issues.
* Can either load external coverage metrics (rcov or simplecov) or run rcov directly.

#### Notes:

* Rcov is not included in the gem, and is off by default.
* Rails best practices is not available in ruby 1.8.
* Version 2.1.3.7.18.1 is currently the last version fully compatible with 1.8.
* Metrical is no longer necessary. Its functionality has been merged into metric_fu.

#### Other work

* Re-organized test files - Michael Stark
* Rspec2 - Michael Stark
* Unify verbose logging with the MF_DEBUG=true commandline flag
* Begin to isolate each metric code. Each metric configures itself
* Clean up global ivars a bit in Configuration
* Thanks to Dan Mayer for helping with churn compatibility
* Thanks to Timo Rößner and Matijs van Zuijlen for their work on maintaining reek

### MetricFu 2.1.3.7.18.1 / 2013-01-09

* Same as 2.1.3.7.18.1 but gem packaged using ruby 1.8 dependencies, including ripper

### MetricFu 2.1.3.7.19 / 2013-01-08

* Bug fix, ensure Configuration is loaded before Run, https://github.com/metricfu/metric_fu/issues/36
* Gem packaged using ruby 1.9 dependencies.  Learned that we cannot dynamically change dependencies for a packaged gem.

### MetricFu 2.1.3.6 / 2013-01-02

* Fixed bug that wasn't show stats or rails_best_practices graphs
* Updated churn and rails_best_practices gems
* Move the metrics code in the rake task into its own file
* Remove executable metric_fu dependency on rake
* TODO: some unclear dependency issues may make metrics in 1.9 crash, esp Flog, Flay, Stats

### MetricFu 2.1.3.5 / 2013-01-01

* Issue #35, Namespace MetricFu::Table. -Benjamin Fleischer
* Additionally namespace
  * MetricFu::CodeIssue
  * MetricFu::MetricAnalyzer
  * MetricFu::AnalysisError
  * MetricFu::HotspotScoringStrategies
* Rename MetricAnalyzer to HotspotAnalyzer, and rename all <metric>Analzyer classes to <metric>Hotspot to signify that they are part of the Hotspot code -Benjamin Fleischer

### MetricFu 2.1.3.4 / 2012-12-28

* Restructuring of the project layout
* Project is now at https://github.com/metricfu/metric_fu and gem is again metric_fu
* Can run tasks as `metric_fu` command

### MetricFu 2.1.3.2 / 2012-11-14

* Don't raise an exception in the LineNumbers rescue block. Issue https://github.com/bf4/metric_fu/issues/6 by joonty -Benjamin Fleischer
 tmp/metric_fu/output/flog.js

### MetricFu 2.1.3 / 2012-10-25

* Added to rubygems.org as bf-metric_fu -Benjamin Fleischer
* Added to travis-ci -Benjamin Fleischer
* Re-enabling Saikuro for ruby 1.9 with jpgolly's gem jpgolly-Saikuro -Benjamin Fleischer
* Ensured files are only loaded once -Benjamin Fleischer
* Looked at moving to simplecov-rcov, but was unsuccessful -Benjamin Fleischer
* Fixed breaking tests, deprecation warnings -Benjamin Fleischer

### MetricFu 2.1.2 / 2012-09-05

* Getting it working on Rails 3, partly by going through the pull requests and setting gem dependencies to older, working versions - Benjamin Fleischer
* It mostly works on Ruby 1.9, though there is an unresolved sexp_parser issue  - Benjamin Fleischer
* Added link_prefix to configuration to allow URIs specified in config instead of file or txmt - dan sinclair

### MetricFu 2.1.1 / 2011-03-2

* Making syntax highlighting optional (config.syntax_highlighting = false) so Ruby 1.9.2 users don't get "invalid byte sequence in UTF-8" errors.

### MetricFu 2.1.0 / 2011-03-1

  In 2.1.0 there are a lot of bug fixes. There's a verbose mode (config.verbose = true) that's helpful for debugging (from Dan Sinclair), the ability to opt out of TextMate (from Kakutani Shintaro) opening your files (config.darwin_txmt_protocol_no_thanks = true), and super cool annotations on the Hotspots page so you can see your code problems in-line with the file contents (also from Dan Sinclair).

* Flog gemspec version was >= 2.2.0, which was too early and didn't work. Changed to >= 2.3.0 -  Chris Griego
* RCov generator now uses a regex with begin and end line anchor to avoid splitting on comments with equal signs in source files - Andrew Selder
* RCov generator now always strips the 3 leading characters from the lines when reconstruction source files so that heredocs and block comments parse successfully - Andrew Selder
* Dan Mayer ported some specs for the Hotspots code into MetricFu from Caliper's code.
* Stefan Huber fixed some problems with churn pretending not to support Svn.
* Kakutani Shintaro added the ability to opt out of opening files with TextMate (config.darwin_txmt_protocol_no_thanks = true).
* Joel Nimety and Andrew Selder fixed a problem where Saikuro was parsing a dir twice.
* Dan Sinclair added some awesome 'annotate' functionality to the Hotspots page. Click on it so see the file with problems in-line.
* Dan Sinclair added a verbose mode (config.verbose = true).

### MetricFu 2.0.1 / 2010-11-13

* Delete trailing whitespaces - Delwyn de Villiers
* Stop Ubuntu choking on invalid multibyte char (US-ASCII) - Delwyn de Villiers
* Fix invalid next in lib/base/metric_analyzer.rb - Delwyn de Villiers
* Don't load Saikuro for Ruby 1.9.2 - Delwyn de Villiers
* Fixed a bug reported by Andrew Davis on the mailing list where configuring the data directory causes dates to be 0/0 - Joshua Cronemeyer

### MetricFu 2.0.0 / 2010-11-10

In 2.0.0 the big new feature is Hotspots.  The Hotspots report combines Flog, Flay, Rcov, Reek, Roodi, and Churn numbers into one report so you see parts of your code that have multiple problems like so:

![Hotspots](http://metric-fu.rubyforge.org/hotspot.gif "That is one terrible method")

Big thanks to Dan Mayer and Ben Brinckerhoff for the Hotspots code and for helping me integrate it with RCov.

* Hotspots - Dan Mayer, Ben Brinckerhoff, Jake Scruggs
* Rcov integration with Hotspots - Jake Scruggs, Tony Castiglione, Rob Meyer

### MetricFu 1.5.1 / 2010-7-28

* Patch that allows graphers to skip dates that didn't generate metrics for that graph (GitHub Issue #20). - Chris Griego
* Fixed bug where if you try and use the gchart grapher with the rails_best_practices metric, it blows up (GitHub Issue #23). - Chris Griego
* Fixed 'If coverage is 0% metric_fu will explode' bug (GitHub Issue #6). - Stew Welbourne

### MetricFu 1.5.0 / 2010-7-27

* Fixed bug where Flay results were not being reported.  Had to remove the ability to remove selected files from flay processing (undocumented feature that may go away soon if it keeps causing problems).
* Rewrote Flog parsing/processing to use Flog programmatically. Note: the yaml output for Flog has changed significantly - Pages have now become MethodContainers.  This probably doesn't matter to you if you are not consuming the metric_fu yaml output.
* Added support for using config files in Reek and Roodi (roodi support was already there but undocumented).
* Removed verify_dependencies! as it caused too much confusion to justify the limited set of problems it solved. In the post Bundler world it just didn't seem necessary to limit metric_fu dependencies.
* Deal with Rails 3 activesupport vs active_support problems. -  jinzhu

### MetricFu 1.4.0 / 2010-06-19

* Added support for rails_best_practices gem - Richard Huang
* Added rails stats graphing -- Josh Cronemeyer
* Parameterize the filetypes for flay. By default flay supports haml as well as rb and has a plugin ability for other filetypes. - bfabry
* Support for Flog 2.4.0 line numbers - Dan Mayer
* Saikuro multi input directory patch - Spencer Dillard and Dan Mayer
* Can now parse rcov analysis file coming from multiple sources with an rcov :external option in the config. - Tarsoly András
* Fixed open file handles problem in the Saikuro analyzer - aselder, erebor
* Fix some problems with the google charts - Chris Griego
* Stop showing the googlecharts warning if you are not using google charts.

### MetricFu 1.3.0 / 2010-01-26

* Flay can be configured to ignore scores below a threshold (by default it ignores scores less than 100)
* When running Rcov you can configure the RAILS_ENV (defaults to 'test') so running metric_fu doesn't interfere with other environments
* Changed devver-construct (a gem hosted by GitHub) development dependency to test-construct dependency (on Gemcutter) - Dan Mayer
* Upgrade Bluff to 0.3.6 and added tooltips to graphs - Édouard Brière
* Removed Saikuro from vendor and added it as a gem dependency - Édouard Brière
* Churn has moved outside metric_fu and is now a gem and a dependency - Dan Mayer
* Fix 'activesupport' deprecation (it should be 'active_support') - Bryan Helmkamp
* Declared development dependencies
* Cleaned and sped up specs

### MetricFu 1.2.0 / 2010-01-09

* ftools isn't supported by 1.9 so moved to fileutils.
* Overhauled the graphing to use Gruff or Google Charts so we no longer depend on ImageMagick/rmagick -- thanks to Carl Youngblood.
* Stopped relying on Github gems as they will be going away.

### MetricFu 1.1.6 / 2009-12-14

* Now compatible with Reek 1.2x thanks to Kevin Rutherford
* Fixed problem with deleted files still showing up in Flog reports thanks to Dan Mayer

### MetricFu 1.1.5 / 2009-8-13

* Previous Ruby 1.9 fix was not quite fix-y enough

### MetricFu 1.1.4 / 2009-7-13

* Fixed another Ruby 1.9x bug

### MetricFu 1.1.3 / 2009-7-10

* MetricFu is now Ruby 1.9x compatible
* Removed the check for deprecated ways of configuring metric_fu as the tests were causing Ruby 1.9x problems and it's been forever since they were supported.
* Removed total flog score from graph (which will always go up and so doesn't mean much) and replacing it with top_five_percent_average which is an average of the worst 5 percent of your methods.
* Sort Flog by highest score in the class which I feel is more important than the total flog flog score.

### MetricFu 1.1.2 / 2009-7-09

* Removed dependency on gruff and rmagick (unless the user wants graphs, of course).
* New look for styling -- Edouard Brière
* Extra param in rcov call was causing problems -- Stewart Welbourne
* Preventing rake task from being run multiple times when other rake tasks switch the environment -- Matthew Van Horn
* Typo in Rcov dependency verification and fixing parsing Saikuro nested information -- Mark Wilden

### MetricFu 1.1.1 / 2009-6-29

* Fix for empty flog files

### MetricFu 1.1.0 / 2009-6-22

* Flog, flay, reek, roodi, and rcov reports now graph progress over time.  Well done Nick Quaranto and Edouard Brière.
* 'Awesome' template has been brought in so that reports look 90% less 'ghetto.'  Also done by Nick Quaranto and Edouard Brière.
* Added links to TextMate (which keep getting removed.  Probably by me. Sorry.) -- David Chelimsky
* Fixed a bug for scratch files which have a size of 0 -- Kevin Hall
* Changed gem dependencies from install-time in gemspec to runtime when each of the generators is loaded.  This allows use of github gems (i.e. relevance-rcov instead of rcov) and also allows you to install only the gems for the metrics you plan on using.  -- Alex Rothenberg
* Empty Flog file fix -- Adam Bair
* Added a simple fix for cases where Saikuro results with nested information -- Randy Souza
* Fixed rcov configuration so it ignores library files on Linux -- Diego Carrion
* Changing churn so that it still works deeper than the git root directory -- Andrew Timberlake
* Andrew Timberlake also made some nice changes to the base template which kinda of got overshadowed by the 'awesome' template.  Sorry about that Andrew.

### MetricFu 1.0.2 / 2009-5-11

* Fixing problems with Reek new line character (thanks to all who pointed this out)
* Flog now recognizes namespaces in method names thanks to Daniel Guettler
* Saikuro now looks at multiple directories, again.

### MetricFu 1.0.1 / 2009-5-3

* metrics:all task no longer requires a MetricFu::Configuration.run {} if you want to accept the defaults
* rcov task now reports total coverage percent

### MetricFu 1.0.0 / 2009-4-30

* Merged in Grant McInnes' work on creating yaml output for all metrics to aid harvesting by other tools
* Supporting Flog 2.1.0
* Supporting Reek 1.0.0
* Removed dependency on Rails Env for 3.months.ago (for churn report), now using chronic gem ("3 months ago").
* Almost all code is out of Rakefiles now and so is more easily testable
* Metrics inherit from a refactored Generator now.  New metrics generators just have to implement "emit", "analyze", "to_h" and inherit from Generator.  They also must have a template.  See the flay generator and template for a simple implementation.
* You now define the metrics you wish to run in the configuration and then run "metrics:all".  No other metrics task is exposed by default.

### MetricFu 0.9.0 / 2009-1-25

* Adding line numbers to the views so that people viewing it on cc.rb can figure out where the problems are
* Merging in changes from Jay Zeschin having to do with the railroad task -- I still have no idea how to use it (lemme know if you figure it out)
* Added totals to Flog results
* Moved rcov options to configuration

### MetricFu 0.8.9 / 2009-1-20

* Thanks to Andre Arko and Petrik de Heus for adding the following features:
* The source control type is auto-detected for Churn
* Moved all presentation to templates
* Wrote specs for all classes
* Added flay, Reek and Roodi metrics
* There's now a configuration class (see README for details)
* Unification of metrics reports
* Metrics can be generated using one command
* Adding new metrics reports has been standardized

### MetricFu 0.8.0 / 2008-10-06

* Source Control Churn now supports git (thanks to Erik St Martin)
* Flog Results are sorted by Highest Flog Score
* Fix for a bunch of 'already initialized constant' warnings that metric_fu caused
* Fixing bug so the flog reporter can handle methods with digits in the name (thanks to Andy Gregorowicz)
* Internal Rake task now allows metric_fu to flog/churn itself

### MetricFu 0.7.6 / 2008-09-15

* CHURN_OPTIONS has become MetricFu::CHURN_OPTIONS
* SAIKURO_OPTIONS has become MetricFu::SAIKURO_OPTIONS
* Rcov now looks at test and specs
* Exclude gems and Library ruby code from rcov
* Fixed bug with churn start_date functionality (bad path)

### MetricFu 0.7.5 / 2008-09-12

* Flog can now flog any set of directories you like (see README).
* Saikuro can now look at any set of directories you like (see README).

### MetricFu 0.7.1 / 2008-09-12

* Fixed filename bugs pointed out by Bastien

### MetricFu 0.7.0 / 2008-09-11

* Merged in Sean Soper's changes to metric_fu.
* Metric_fu is now a gem.
* Flogging now uses a MD5 hash to figure out if it should re-flog a file (if it's changed)
* Flogging also has a cool new output screen(s)
* Thanks Sean!

    ### Metricks 0.4.2 / 2008-07-01

    * Changed rcov output directory so that it is no longer 'coverage/unit' but just 'coverage' for better integration with CC.rb

    ### Metricks 0.4.1 / 2008-06-13

    * Rcov tests now extend beyond one level depth directory by using RcovTask instead of the shell

    ### Metricks 0.4.0 / 2008-06-13

    * Implementing functionality for use as a gem
    * Added Rakefile to facilitate testing

    ### Metricks 0.3.0 / 2008-06-11

    * Generated reports now open on darwin automatically
    * Generated reports reside under tmp/metricks unless otherwise specified by ENV['CC_BUILD_ARTIFACTS']
    * MD5Tracker works with Flog reports for speed optimization

    ### Metricks 0.2.0 / 2008-06-11

    * Integrated use of base directory constant
    * Have all reports automatically open in a browser if platform is darwin
    * Namespaced under Metricks
    * Dropped use of shell md5 command in favor of Ruby's Digest::MD5 libraries

    ### Metricks 0.1.0 / 2008-06-10

    * Initial integration of metric_fu and my enhancements to flog
    * Metrics are generated but are all over the place

### MetricFu 0.6.0 / 2008-05-11

* Add source control churn report

### MetricFu 0.5.1 / 2008-04-25

* Fixed bug with Saikuro report generation - thanks Toby Tripp

### MetricFu 0.5.0 / 2008-04-25

* create MetricFu as a Rails Plugin
* Add Flog Report
* Add Coverage Report
* Add Saikuro Report
* Add Stats Report
