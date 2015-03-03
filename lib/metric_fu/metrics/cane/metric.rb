module MetricFu
  class MetricCane < Metric
    def name
      :cane
    end

    def default_run_options
      {
        dirs_to_cane: MetricFu::Io::FileSystem.directory("code_dirs"),
        abc_max: 15,
        line_length: 80,
        no_doc: "n",
        no_readme: "n",
        filetypes: ["rb"]
      }
    end

    def has_graph?
      true
    end

    def enable
      if MetricFu.configuration.supports_ripper? && !MetricFu.configuration.ruby18?
        super
      else
        MetricFu.logger.debug("Cane is only available in MRI. It requires ripper and 1.9 hash syntax support")
      end
    end

    def activate
      super
    end
  end
end
