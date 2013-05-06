require 'pathname'
require 'erb'
module MetricFu

  # The Template class is intended as an abstract class for concrete
  # template classes to subclass.  It provides a variety of utility
  # methods to make templating a bit easier.  However, classes do not
  # have to inherit from here in order to provide a template.  The only
  # requirement for a template class is that it provides a #write method
  # to actually write out the template.  See StandardTemplate for an
  # example.
  class Template
    attr_accessor :report, :per_file_data

    private
    # Creates a new erb evaluated result from the passed in section.
    #
    # @param section String
    #   The section name of
    #
    # @return String
    #   The erb evaluated string
    def erbify(section)
      erb_doc = File.read(template(section))
      ERB.new(erb_doc).result(binding)
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
      if MetricFu.metrics.include?(section) # expects a symbol
        File.join(template_dir(section.to_s), "#{section}.html.erb")
      else
        File.join(template_directory,  section.to_s + ".html.erb")
      end
    end
    def template_dir(metric)
      File.join(MetricFu.metrics_dir, metric, metric_template_dir)
    end
    # e.g. template_awesome, template_standard
    def metric_template_dir
      template_name = self.class.name.sub('Template', '')[/^([A-Z][a-z]+)+/].downcase
      "template_#{template_name}"
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
      open(File.join(template_directory, css)) { |f| f.read }
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
      "<a href='#{file_url(name, line)}'>#{link_content(name, line, link_content)}</a>"
    end

    def round_to_tenths(decimal)
      decimal = 0.0 if decimal.to_s.eql?('NaN')
      (decimal * 10).round / 10.0
    end

    def link_content(name, line=nil, link_content=nil) # :nodoc:
      if link_content
        link_content
      elsif line
        "#{name}:#{line}"
      else
        name
      end
    end

    def display_location(location, stat)
      file_path, class_name, method_name = location.file_path, location.class_name, location.method_name
      str = ""
      str += link_to_filename(file_path)
      str += " : " if method_name || class_name
      if(method_name)
        str += "#{method_name}"
      else
        #TODO HOTSPOTS BUG ONLY exists on move over to metric_fu
        if class_name.is_a?(String)
          str+= "#{class_name}"
        end
      end
      str
    end

    def file_url(name, line) # :nodoc:
      return '' unless name
      filename = complete_file_path(name)
      link_prefix = MetricFu.configuration.link_prefix
      if link_prefix
        "#{link_prefix}/#{name.gsub(/:.*$/, '')}"
      elsif render_as_txmt_protocol?
        "txmt://open/?url=file://#{filename}" << (line ? "&line=#{line}" : "")
      # elsif render_as_mvim_protocol?
      #   "mvim://open/?url=file://#{filename}" << (line ? "&line=#{line}" : "")
      else
       "file://#{filename}"
      end
    end

    def complete_file_path(filename)
      File.expand_path(remove_leading_slash(filename))
    end

    def remove_leading_slash(filename)
      filename.gsub(/^\//, '')
    end
    def render_as_txmt_protocol? # :nodoc:
      config = MetricFu.configuration
      return false unless config.platform.include?('darwin')
      return !config.darwin_txmt_protocol_no_thanks
    end
    def render_as_mvim_protocol? # :nodoc:
      config = MetricFu.configuration
      return false unless config.platform.include?('darwin')
      return !config.darwin_mvim_protocol_no_thanks
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
      return second_value
    end

    # available in the erb template
    # as it's processed in the context of
    # the binding of this class
    def metric_links
      @metrics.keys.map {|metric| metric_link(metric.to_s) }
    end

    def metric_link(metric)
      <<-LINK
      <a href="#{metric}.html">
        #{snake_case_to_title_case(metric)}
      </a>
      LINK
    end

    def snake_case_to_title_case(string)
     string.split('_').collect{|word| word[0] = word[0..0].upcase; word}.join(" ")
    end

    # belive me, I tried to meta program this with an inherited hook
    # I couldn't get it working
    def template_directory
      raise "you need to define this method in each subclass with File.dirname(__FILE__)"
      # def template_directory
      #   File.dirname(__FILE__)
      # end
    end
  end
end
