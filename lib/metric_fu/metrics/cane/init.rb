MetricFu::Configuration.run do |config|
  config.add_metric(:cane)
  config.add_graph(:cane)
  config.configure_metric(:cane, {
    :dirs_to_cane => MetricFu.code_dirs,
    :abc_max => 15,
    :line_length => 80,
    :no_doc => 'n',
    :no_readme => 'n',
    :filetypes => ['rb']
  })
end

