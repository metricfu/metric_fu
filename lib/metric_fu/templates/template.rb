require "erb"
module MetricFu
  class Template
    attr_accessor :output_directory

    def output_directory
      @output_directory || MetricFu::Io::FileSystem.directory("output_directory")
    end

    # Renders a partial and add optional instance variables to the template
    # @param name <String> name of partial, omitting leading underscore (_)
    # @param instance_variables <Hash> of instance variable
    # names and values to set
    def render_partial(name, instance_variables = {})
      create_instance_vars(instance_variables)
      erbify("_#{name}")
    end

    private

    # Creates a new erb evaluated result from the passed in section.
    #
    # @param section String
    #   The section name of
    #
    # @return String
    #   The erb evaluated string
    def erbify(section)
      template_file = template(section)
      erb           = erb_template_source(template_file)
      erb.result(binding)
    rescue => e
      message = "Error: #{e.class}; message #{e.message}. "
      message << "Failed evaluating erb template "
      message << "for section #{section} and template #{template_file}."
      raise message
    end

    def erb_template_source(template_file)
      erb_doc       = File.read(template_file)
      erb           = ERB.new(erb_doc)
      erb.filename  = template_file
      erb
    end

    # Copies an instance variable mimicing the name of the section
    # we are trying to render, with a value equal to the passed in
    # constant.  Allows the concrete template classes to refer to
    # that instance variable from their ERB rendering
    #
    # @param section String
    #  The name of the instance variable to create
    #
    # @param contents Object
    #   The value to set as the value of the created instance
    #   variable
    def create_instance_var(section, contents)
      instance_variable_set("@#{section}", contents)
    end

    def create_instance_vars(variables)
      variables.each { |variable| create_instance_var(*variable) }
    end

    # Generates the filename of the template file to load and
    # evaluate.  In this case, the path to the template directory +
    # the section name + .html.erb
    #
    # @param section String
    #   A section of the template to render
    #
    # @return String
    #   A file path
    def template(section)
      # TODO: each MetricFu::Metric should know about its templates
      #  This class knows too much about the filesystem structure
      if MetricFu::Metric.enabled_metrics.map(&:name).include?(section) # expects a symbol
        metric_template_path(section.to_s)
      else
        File.join(template_directory,  section.to_s + ".html.erb")
      end
    end

    def metric_template_path(metric)
      File.join(MetricFu.metrics_dir, metric, "report.html.erb")
    end

    # Determines whether a template file exists for a given section
    # of the full template.
    #
    # @param section String
    #   The section of the template to check against
    #
    # @return Boolean
    #   Does a template file exist for this section or not?
    def template_exists?(section)
      File.exist?(template(section))
    end

    # Returns the filename that the template will render into for
    # a given section.  In this case, the section name + '.html'
    #
    # @param section String
    #   A section of the template to render
    #
    # @return String
    #   The output filename
    def output_filename(section)
      section.to_s + ".html"
    end

    # Returns the contents of a given css file in order to
    # render it inline into a template.
    #
    # @param css String
    #   The name of a css file to open
    #
    # @return String
    #   The contents of the css file
    def inline_css(css)
      css_file = File.join(MetricFu.lib_dir, "templates", css)
      MetricFu::Utility.binread(css_file)
    end

    # Provides a link to open a file through the textmate protocol
    # on Darwin, or otherwise, a simple file link.
    #
    # @param name String
    #
    # @param line Integer
    #   The line number to link to, if textmate is available.  Defaults
    #   to nil
    #
    # @return String
    #   An anchor link to a textmate reference or a file reference
    def link_to_filename(name, line = nil, link_content = nil)
      href = file_url(name, line)
      link_text = link_content(name, line, link_content)
      "<a href='#{href}'>#{link_text}</a>"
    end

    def round_to_tenths(decimal)
      decimal = 0.0 if decimal.to_s.eql?("NaN")
      (decimal * 10).round / 10.0
    end

    def link_content(name, line = nil, link_content = nil) # :nodoc:
      if link_content
        link_content
      elsif line
        "#{name}:#{line}"
      else
        name
      end
    end

    def display_location(location)
      class_name, method_name = location.fetch("class_name"), location.fetch("method_name")
      str = ""
      str += link_to_filename(location.fetch("file_name"), location.fetch("line_number"))
      str += " : " if method_name || class_name
      if method_name
        str += "#{method_name}"
      else
        # TODO HOTSPOTS BUG ONLY exists on move over to metric_fu
        if class_name.is_a?(String)
          str += "#{class_name}"
        end
      end
      str
    end

    def file_url(name, line) # :nodoc:
      return "" unless name
      filename = complete_file_path(name)

      if render_as_txmt_protocol?
        "txmt://open/?url=file://#{filename}" << (line ? "&line=#{line}" : "")
      else
        link_prefix = MetricFu.configuration.templates_option("link_prefix")
        if link_prefix == MetricFu::Templates::Configuration::FILE_PREFIX
          path = filename
        else
          path = name.gsub(/:.*$/, "")
        end
        "#{link_prefix}/#{path}"
      end
    end

    def complete_file_path(filename)
      File.expand_path(filename)
    end

    def render_as_txmt_protocol? # :nodoc:
      if MetricFu.configuration.osx?
        !MetricFu.configuration.templates_option("darwin_txmt_protocol_no_thanks")
      else
        false
      end
    end

    # Provides a brain dead way to cycle between two values during
    # an iteration of some sort.  Pass in the first_value, the second_value,
    # and the cardinality of the iteration.
    #
    # @param first_value Object
    #
    # @param second_value Object
    #
    # @param iteration Integer
    #   The number of times through the iteration.
    #
    # @return Object
    #   The first_value if iteration is even.  The second_value if
    #   iteration is odd.
    def cycle(first_value, second_value, iteration)
      return first_value if iteration % 2 == 0
      second_value
    end

    # available in the erb template
    # as it's processed in the context of
    # the binding of this class
    def metric_links
      @metrics.keys.map { |metric| metric_link(metric.to_s) }
    end

    def metric_link(metric)
      <<-LINK
      <a href="#{metric}.html">
        #{snake_case_to_title_case(metric)}
      </a>
      LINK
    end

    def snake_case_to_title_case(string)
      string.split("_").collect { |word| word[0] = word[0..0].upcase; word }.join(" ")
    end

    def template_directory
      fail "subclasses must specify template_directory. Usually File.dirname(__FILE__)"
    end
  end
end
