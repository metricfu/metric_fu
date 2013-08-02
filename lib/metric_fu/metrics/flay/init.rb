MetricFu::Configuration.run do |config|
  require 'flay'
  config.add_metric(:flay)
  config.add_graph(:flay)
  config.configure_metric(:flay,
                    { :dirs_to_flay => MetricFu.code_dirs, # was @code_dirs
                      # MetricFu has been setting the minimum score as 100 for
                      # a long time. This is a really big number, considering
                      # the default is 16. Commenting it out for documentation
                      # of the setting, but to use the Flay default.
                      # :minimum_score => 100,
                      :filetypes => ['rb'] }
                          )
end
