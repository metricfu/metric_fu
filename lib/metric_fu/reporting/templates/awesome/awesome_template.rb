require 'fileutils'
MetricFu.metrics_require { 'base_template' }
MetricFu.lib_require { 'templates/report' }

class AwesomeTemplate < MetricFu::Template

  def write
    @name = MetricFu.report_name

    # Copy javascripts to output directory
    Dir[File.join(template_directory, '..', 'javascripts', '*')].each do |f|
      FileUtils.cp(f, File.join(self.output_directory, File.basename(f)))
    end

    @metrics = {}
    result.each_pair do |section, contents|
      if template_exists?(section)
        create_instance_var(section, contents)
        @metrics[section] = contents
        create_instance_var(:per_file_data, per_file_data)
        mf_debug  "Generating html for section #{section} with #{template(section)} for result #{result.class}"
        @html = erbify(section)
        html = erbify('layout')
        fn = output_filename(section)
        formatter.write_template(html, fn)
      else
        mf_debug  "no template for section #{section} with #{template(section)} for result #{result.class}"
      end
    end

    # Instance variables we need should already be created from above
    if template_exists?('index')
      @html = erbify('index')
      html = erbify('layout')
      fn = output_filename('index')
      formatter.write_template(html, fn)
    else
      mf_debug  "no template for section index for result #{result.class}"
    end

    write_file_data
  end

  def write_file_data
    per_file_data.each_pair do |file, lines|
      next if file.to_s.empty?
      next unless File.file?(file)
      report = MetricFu::Templates::Report.new(file, lines).render(@metrics)

      formatter.write_template(report, html_filename(file))
    end
  end

  def html_filename(file)
    "#{file.gsub(%r{/}, '_')}.html"
  end

  def template_directory
    File.dirname(__FILE__)
  end
end

