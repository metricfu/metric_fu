require "fileutils"
MetricFu.lib_require { "templates/template" }
MetricFu.lib_require { "templates/report" }

# The MetricsTemplate class is the included template used by the HTML formatter.
# The only requirement for a template class is that it provides a #write method
# to actually write out the template.
module MetricFu
  class Templates::MetricsTemplate < MetricFu::Template
    attr_accessor :result, :per_file_data, :formatter, :metrics, :name, :html

    def write
      self.name = MetricFu.report_name
      self.metrics = {}

      copy_javascripts

      result.each_pair do |section, contents|
        write_section(section, contents)
      end

      write_index
      write_file_data
    end

    def html_filename(file)
      file = Digest::SHA1.hexdigest(file)[0..29]
      "#{file.gsub(%r{/}, '_')}.html"
    end

    private

    def copy_javascripts
      Dir[File.join(template_directory, "javascripts", "*")].each do |f|
        FileUtils.cp(f, File.join(output_directory, File.basename(f)))
      end
    end

    def write_section(section, contents)
      if template_exists?(section)
        create_instance_var(section, contents)
        metrics[section] = contents
        create_instance_var(:per_file_data, per_file_data)
        mf_debug "Generating html for section #{section} with #{template(section)} for result #{result.class}"
        self.html = erbify(section)
        layout = erbify("layout")
        fn = output_filename(section)
        formatter.write_template(layout, fn)
      else
        mf_debug "no template for section #{section} with #{template(section)} for result #{result.class}"
      end
    end

    def write_index
      # Instance variables we need should already be created from above
      if template_exists?("index")
        self.html = erbify("index")
        layout = erbify("layout")
        fn = output_filename("index")
        formatter.write_template(layout, fn)
      else
        mf_debug "no template for section index for result #{result.class}"
      end
    end

    def write_file_data
      per_file_data.each_pair do |file, lines|
        next if file.to_s.empty?
        next unless File.file?(file)
        report = MetricFu::Templates::Report.new(file, lines).render

        formatter.write_template(report, html_filename(file))
      end
    end

    def template_directory
      File.dirname(__FILE__)
    end
  end
end
