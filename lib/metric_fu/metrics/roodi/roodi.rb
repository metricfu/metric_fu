module MetricFu
  class RoodiGenerator < Generator

    def self.metric
      :roodi
    end

    def emit
      files_to_analyze = options[:dirs_to_roodi].map{|dir| Dir[File.join(dir, "**/*.rb")] }
      files = remove_excluded_files(files_to_analyze.flatten)
      config = options[:roodi_config] ? "-config=#{options[:roodi_config]}" : ""
      command = %Q(mf-roodi #{config} #{files.join(" ")})
      mf_debug "** #{command}"
      @output = `#{command}`
    end

    def analyze
      @matches = @output.chomp.split("\n").map{|m| m.split(" - ") }
      total = @matches.pop
      @matches.reject! {|array| array.empty? }
      @matches.map! do |match|
        file, line = match[0].split(':')
        problem = match[1]
        {:file => file, :line => line, :problem => problem}
      end
      @roodi_results = {:total => total, :problems => @matches}
    end

    def to_h
      {:roodi => @roodi_results}
    end

    def per_file_info(out)
      @matches.each do |match|
        out[match[:file]] ||= {}
        out[match[:file]][match[:line]] ||= []
        out[match[:file]][match[:line]] << {:type => :roodi, :description => match[:problem]}
      end
    end
  end
end
