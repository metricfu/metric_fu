module MetricFu
  class MetricSaikuro < Metric

    def name
      :saikuro
    end

    def default_run_options
      { :output_directory => "#{MetricFu::Io::FileSystem.directory('scratch_directory')}/saikuro",
                    :input_directory =>MetricFu::Io::FileSystem.directory('code_dirs'),
                    :cyclo => "",
                    :filter_cyclo => "0",
                    :warn_cyclo => "5",
                    :error_cyclo => "7",
                    :formater => "text"}
    end

    def has_graph?
      false
    end

    def enable
      super
    end

  end
end
