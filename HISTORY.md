Changes are below categorized as `Breaking changes, Features, Fixes, or Misc`.

Each change should fall into categories that would affect whether the release is major (breaking changes), minor (new behavior), or patch (bug fix). See [semver](http://semver.org/) and [pessimistic versioning](http://docs.rubygems.org/read/chapter/16#page74)

As such, a _Feature_ would map to either major (breaking change) or minor. A _bug fix_ to a patch.  And _misc_ is either minor or patch, the difference being kind of fuzzy for the purposes of history.  Adding tests would be patch level.

### Master [changes](https://github.com/metricfu/metric_fu/compare/v4.11.4...master)

* Breaking Changes
* Features
* Fixes
* Misc

### [4.11.4](https://github.com/metricfu/metric_fu/compare/v4.11.3...v4.11.4)

* Fixes
  * Hash hotspots output filenames. (Martin Gotink, #247, fixes #246)
  * Fix invalid file links for rails best practices (Martin Gotink, #248)
  * Add file links to cane and saikuro reports (Martin Gotink, #248)
  * Fix incorrectly displaying not covered lines. (Martin Gotink, #249)
  * Fix simplecov missing logger dependency. (Martin Gotink, #250, fixes #235)

### [4.11.3](https://github.com/metricfu/metric_fu/compare/v4.11.2...v4.11.3)

* Fixes
  * Fix incorrectly passing --config option to reek. (Martin Gotink, #243, fixes #242)

### [4.11.2](https://github.com/metricfu/metric_fu/compare/v4.11.1...v4.11.2)

* Fixes
  * Use reek as library, otherwise reek >= 1.6.2 hangs while reading input from stdin. (Martin Gotink, #240, fixes #239)
* Misc
  * Refactor MetricFu::Templates::MetricsTemplate#write into a composed method. (#237)

### [4.11.1](https://github.com/metricfu/metric_fu/compare/v4.11.0...v4.11.1)

* Fixes
  * Captured shell-output now only includes STDOUT.  Appending STDERR was breaking expectations. (Benjamin Fleischer, #230, fixes #229)

### [4.11.0](https://github.com/metricfu/metric_fu/compare/v4.10.0...v4.11.0)

* Features
  * There is now a `MetricFu.logger` with standard available configurations.
    The old `mf_debug` and `mf_log` main mixin is presevered.  Needs documentation. See #113. (Benjamin Fleischer, a49bfdd182)
  * Use *launchy* (new dependency) when opening output files. (Nick Veys, #224)
  * Coverage formatter now behaves like SimpleCov; it ignores certain lines in
    calculating the precent run. Fixes #153, #222 (Benjamin Fleischer, #226).
    - Thanks to @crv for the test in #153
    - Note: JRuby will usually report different Coverage from MRI. This is a known issue.
    - Note: This technically is a *breaking change* from how RCov works. But wwe don't run RCov anymore. (65bf21723291f)
* Fixes
  * Ensure paths with spaces don't cause the open command to fail (Nick Veys, #220)
  * Read in source files for annotation in BINARY mode to avoid encoding errors. (Benjamin Fleischer, #216)
  * Start SimpleCov before any MetricFu code is loaded. Coverage isn't tracked on already-loaded code. (Benjamin Fleischer, cca659f7d48d3f6799)
  * Remove unused/invalid Flay param 'filetypes'. Closes #151. (Benjamin Fleischer, 5973595f51c)
* Misc
  * Document ENV variables the may fix encoding exceptions. (Mike Szyndel, #217)
  * Begin adding shared tests for metrics and configuration.  Test fenced-codeblock matching. (Benjamin Fleischer, #221)
  * Reorganize the application file layout. Still more to be done. (Benjamin Fleischer, #223)
  * Rename AwesomeTemplate to MetricFu::Templates::MetricsTemplate.  (Benjamin Fleischer, 55c52afd95d78)
  * Rename ReekHotspot to MetricFu::ReekHotspot.  Was missing namespace. (Benjamin Fleischer, a3aa70c1a9)
  * Allow failures for Ruby 2.1, in addition to rbx per issues with rvm.  (Benjamin Fleischer, 3018b22)
  * `spec/quality_spec.rb` checks for whitespace, tabs, quotes, etc. `rake spec` also checks for warnings. (Benjamin Fleischer, b0c51bb9b17)
  * When run with COVERAGE=true, will ouptut a file to `coverage/coverage_percent.txt` that can be checked via `rake check_code_coverage`. Borrowed from VCR. (Benjamin Fleischer, 32df3a34c6)

### [4.10.0 / 2014-04-01](https://github.com/metricfu/metric_fu/compare/v4.9.0...v4.10.0)

* Features
  * Implement partials for cleaning up double template code (Martin Gotink, #211)
* Fixes
  * Ensure reek output does not include ANSI color escape codes (Ben Turner #213)
* Misc
  * Remove duplicate methods from generator. (Alessandro Dias Batista, #210)
  * Encapsulate methods on MetricFu: report_time, report_id, :report_fingerprint, :current_time. (Benjamin Fleischer, #209)

### [4.9.0 / 2014-03-23](https://github.com/metricfu/metric_fu/compare/v4.8.0...v4.9.0)

* Features
  * Add SimpleCov::Formatter::MetricFu, compatible with legacy RCov format (Benjamin Fleischer with h/t Michael @kina, #201)
  * Add Highcharts JS as available graphing engine (Martin Gotink, #205)

### [4.8.0 / 2014-02-24](https://github.com/metricfu/metric_fu/compare/v4.7.4...v4.8.0)

* Features
  * Add configurable `MetricFu.report_name`. (Paul Swagerty, #203)

### [4.7.4 / 2014-02-16](https://github.com/metricfu/metric_fu/compare/v4.7.3...v4.7.4)

* Fixes
  * Reek no longer crashes when reporting no warnings (Michael Stark, #199)
  * Prevent Roodi non-metric output from ending up in the results (Martin Gotink #202)
  * Coverage file is only read in when the specified external file exists. (Benjamin Fleischer, #156)
  * Metrics are configured to default values before the user config is loaded (Benjamin Fleischer, #156, #78)

### [4.7.3 / 2014-02-09](https://github.com/metricfu/metric_fu/compare/v4.7.2...v4.7.3)

* Fixes
  * Add `strip_escape_codes`; remove from Roodi output. (Przemysław Dąbek, #197)
* Misc
  * Fix markdown in README. (Guilherme Simões, #198)
  * Add Ruby 2.1 to Travis CI build. (Michael Stark , #200)


### [4.7.2 / 2014-01-21](https://github.com/metricfu/metric_fu/compare/v4.7.1...v4.7.2)

* Fixes
  * Open Saikuro scratch files in BINARY; fixes #190. (Benjamin Fleischer, #195)
  * Update to churn 0.0.35 for API compatibility. (Przemysław Dąbek, #193)
  * Only specify reek config when set; disable line numbers. (Benjamin Fleischer, #196)

### [4.7.1 / 2014-01-01](https://github.com/metricfu/metric_fu/compare/v4.7.0...v4.7.1)

* Fixes
  * Check for activated gems now works on earlier versions of RubyGems. (Benjamin Fleischer)

### [4.7.0 / 2013-12-31](https://github.com/metricfu/metric_fu/compare/v4.6.0...v4.7.0)

* Features
  * Move to using churn library and allowing all churn options to be passed through to churn library. (Dan Mayer, #182)
  * Create template for syntax highlighting in report.  (Benjamin Fleischer, #179)
  * Gem deps now derirved from gemspec via regex (from Gemnasium). Related to #184.
    `--debug-info` will now show the version of the activated gem, if available.  (Benjamin Fleischer, #189)
* Fixes
  * Force gemspec to use utf-8 encoding when importing the AUTHORS file. (Paul Swagerty, #183)
  * Ensure gemspec doesn't crash when reading in AUTHORS file. (saltracer, #184)
  * Fix bad parsing of reek output. (Greg Allen, #185)
* Misc
  * Spelling correction. (mdb, #177)
  * Clean up README indentation. (simi, #187)
  * Tests run faster. (Benjamin Fleischer, #181)
  * Simplify load paths. (Benjamin Fleicher, #139)
  * Update to RSpec 3.0.0.beta1. (Benjamin Fleischer)
  * Update to new release of TestConstruct. (Benjamin Fleischer)

### MetricFu [4.6.0 / 2013-11-20](https://github.com/metricfu/metric_fu/compare/v4.5.2...v4.6.0)

* Features
  * Allow configuration of the generation template, eg link_prefix (Adrien Montfort, #171)
* Fixes
  * Return 0% coverage when the file has no lines. (Chirag Viradiya #152, Benjamin Fleischer, Michael Foley)
  * Return stats code to test ratio of 0.0 when NaN (Benjamin Fleischer, reported by Greg Allen)
* Misc

### MetricFu [4.5.2 / 2013-11-07](https://github.com/metricfu/metric_fu/compare/v4.4.4...v4.5.2)

* Misc
  * Exclude etc dir from built gem; save 1.1MB by not including erd.png. (Benjamin Fleischer, #173)

### MetricFu [4.5.1 / 2013-11-07](https://github.com/metricfu/metric_fu/compare/v4.4.4...v4.5.1)

* Features
* Fixes
* Misc
  * Releasing the signed gem didn't work. See ed2f96d8

### MetricFu [4.5.0 / 2013-11-07](https://github.com/metricfu/metric_fu/compare/v4.4.4...v4.5.0)

* Features
  * Signed gem; added certs/bf4.pem
  * Run metrics without shelling out; use Open3.popen3 (Benjamin Fleischer, #157)
    - GemRun runs external libraries, outputs nice error messages
    - GemVersion returns version requirements for a gem dependency; replaces metric_fu_requires
    - Consolidate code that runs external metrics to the generator
    - `--debug-info` now outputs metric dependencies
  * Add new MetricFu.run_dir that defaults to Pathname.pwd, but can be set (Benjamin Fleischer, #160)
    - Used in dummy app for testing 9fcc085
  * User config (.metrics) now loaded when metric_fu required (Benjamin Fleischer, #158)
  * Consolidate grapher code; remove gchart grapher (Benjamin Fleischer, 5fd8f4)
    - Remove bluff gem; bluff grapher is a js library.  (Benjamin Fleischer, 8b534c7)
  * Better rake tasks: can set options form the task (Benjamin Fleischer, 11ac27)
    - Add ::run(options) and ::run_only(metric_name) to MetricFu namespace
* Fixes
  * Churn hotspot no longer tries to read directories as if they were files (Adrien Montfort, #169)
  * Set default Reek config to config/*.reek, per Reek docs (Benjamin Fleischer, #165)
    - Ensure .reek still loaded, for backwards-compatibility
  * Bump reek patch version due to change in meaning in reek config (Benjamin Fleischer, #166)
  * Cleanup scratch files Saikuro leaves behind; else they are re-used! (Benjamin Fleischer, 91ac9af)
  * Various IO-related fixes
    - Close read pipe when capturing output, per @eclubb, Earle Clubb (6696d42)
    - Stop leaving files open everywhere, even though 'everyone does it'. (Benjamin Fleischer, #159)
    - Isolate file-system interactions in specs; rbx specs can pass (Benjamin Fleischer, #161)
  * Remove unused before/after generator methods; standardize not_implemented message (Benjamin Fleischer, 5842d83)
* Misc
  * Update README, and how to contribute (Benjamin Fleischer, #114)
  * Set sane defaults for generator per_file_data hash (Benjamin Fleischer, d991fb8)
  * Ensure gemspec reads AUTHORS from relative path (Benjamin Fleischer, ee0274f)
  * Configure SimpleCov to run with the html and rcov text formatters (Benjamin Fleischer, d372d00)
  * Extract CLI option parsing methods (Benjamin Fleischer, a54d018)
  * Test improvements
    - Update setup, add pry (Benjamin Fleischer)
      - Add rspec FAIL_FAST option (bd2745a)
      - Update spec_helper, add filters, defer gc (3db59d7)
      - Configure tests not to manage GC under JRuby (000200b)
      - Remove FakeFS; doesn't seem to be speeding up the tests, but it does break them (afc5518)
    - Cache test fixtures. (And rename from resources to fixtures.) (Benjamin Fleischer, #164)
    - Set timeout on each test (Benjamin Fleischer, f1d5f20)
    - Add devtools-derived guardfile and configs (Benjamin Fleischer, e2463de)
   - Ensure RailsBestPractices test runs when available (Benjamin Fleischer, #150)

add all contriubtors

### MetricFu [4.4.4 / 2013-09-27](https://github.com/metricfu/metric_fu/compare/v4.4.3...v4.4.4)

* Features
* Fixes
  * Update rcov config instructions in README to include call to activate (Carlos Fernandez, #145)
  * rcov hotspot analyzer (MetricFu::RcovHotspot) now overrides map_strategy instead of map (Carlos Fernandez, #145)
  * Fix test failures relating to artifact directory missing (Benjamin Fleischer, #144)
* Misc

### MetricFu [4.4.3 / 2013-09-25](https://github.com/metricfu/metric_fu/compare/v4.4.2...v4.4.3)

* Features
* Fixes
  * Scratch directory no longer dependent on generator class name. Saikuro works again! (Benjamin Fleischer, #141)
* Misc
  * Metric scratch directory now set via Metric `run_options[:output_directory] || MetricFu::Io::FileSystem.scratch_directory(metric)` (Benjamin Fleischer, #141)

### MetricFu [4.4.2 / 2013-09-25](https://github.com/metricfu/metric_fu/compare/v4.4.1...v4.4.2)

* Features
  * Add --debug-info command line switch to get debug info for Issues. (calveto, #118)
* Fixes
  * Return valid line locations for code with either no AST or nil nodes (Benjamin Fleischer, #137)
  * Only use FakeFS on MRI.  Avoid intermittent failures on JRuby or Rubinius (Benjamin Fleischer, #135)
  * Hotspots no longer serialize actual classes to YAML. (Benjamin Fleischer, #128)
* Misc
  * Extract SexpNode class from LineNumbers to handle Sexp Processing (Benjamin Fleischer, #137)
  * Separate out Hotspot ranked problem location and misc code improvements (Benjamin Fleischer, #128)
  * Identify directories with code to analyze by checking if they exist. (No longer use :rails? as a proxy for checking if we should run on 'app'). (George Erickson, #129)

### MetricFu [4.4.1 / 2013-08-29](https://github.com/metricfu/metric_fu/compare/v4.4.0...v4.4.1)

* Features
* Fixes
  * No longer consider an empty sexp in LineNumbers an error.  A file with only comments is empty of code. (Benjamin Fleischer)
  * Prevent encoding errors when using syntax highlighting via coderay (Benjamin Fleischer #120, #131)
* Misc
  * Update dependencies: cane, flay, flog, reek; switch from metric_fu-roodi to revived roodi (Benjamin Fleischer #130)
  * Update to fully ruby_parser-compatible rails_best_practices (Benjamin Fleischer #133)
  * Hotspots: remove legacy test code, reduce duplication (Benjamin Fleischer, #127, #77)
  * Remove a lot of dead code (Benjamin Fleischer, #77)

### MetricFu 4.4.0 / 2013-08-15

* Breaking Changes
  * Removed configuration methods / MetricFu module methods: add_graph, add_metric, configure_graph, configure_metric, configure_graph_engine, graph_engine, metrics, formatters, graphs, graph_engines, rails?, code_dirs, base_directory, scratch_directory, output_directory, data_directory, file_globs_to_ignore, metric_fu_root_directory, template_directory, template_class, link_prefix, darwin_txmt_protocol_no_thanks, syntax_highlighting
* Features
  * Metrics now configure themselves in a subclass of MetricFu::Metric ( Benjamin Fleischer / Robin Curry #91, #111)
  * Metrics can be configured individually via Metric.configuration.configure_metric(:some_metric) or Metric.configuration.configure_metrics {|metric| }.  See .metrics file for examples ( Benjamin Fleischer / Robin Curry #91, #111)
  * Distinguish between an activated metric library and an enabled metric.
    * An enabled metric will be run.
    * An activated metric has had its library successfully required. (Benjamin Fleischer #125)
  * Code Statistics metrics always runs now, relies on the code_metrics gem extracted from Rails. Does not shell out. ( Benjamin Fleischer, #108 )
  * Rails Best Practices report now provides a link to the description and solution of the problem (Calveto #117)
  * Rails Best Practices now runs as a library. It is no longer shelled out. (Calveto #117)
  * Update flog to ~> 4.1.1, this is needed to use keyword parameters in ruby 2. (George Erickson, #122)
* Fixes
  * Skip reek when no files are found to run against.  Otherwise, reek hangs trying to read from STDIN (Benjamin Fleischer, #119, #121)
  * Reek will now find files on Windows.  Remove *nix-specific '/' directory separators from Reek file glob.  (Benjamin Fleischer, #119, #121)
  * Link to correct reek url on report. (Calveto #116)
  * Hack to accomodate Rails Best Practices dependency Code Analyzer monkey patch of Sexp (Benjamin Fleischer #123, #124)
* Misc
  * Moved environmental concerns into an Environment module ( Benjamin Fleischer / Robin Curry #91, #111)
  * Exposed RubyParser patch ( Benjamin Fleischer / Robin Curry #91, #111)
  * Separated out io / filesystem /templating concerns into their own classes or modules. Thus, we removed all the metaprogrammatically defined methods and instance variables.( Benjamin Fleischer / Robin Curry #91, #111, #112, #115)
  * Generator subclasses can now be found by metric name. MetricFu::Generator.get_generator(:flog) (Benjamin Fleischer, #126)

### MetricFu 4.3.1 / 2013-08-02

* Features
* Fixes
* Misc
  * Don't set a default flay minimum score (was 100); use flay default (16) instead. (Robin Curry #110)
  * Loosen gem dependencies.  Please report any bugs! (Benjamin Fleischer, #109)

### MetricFu 4.3.0 / 2013-07-26

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
