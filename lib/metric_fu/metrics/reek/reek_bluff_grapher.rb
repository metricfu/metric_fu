MetricFu.metrics_require   { 'reek/reek_grapher' }
module MetricFu
  class ReekBluffGrapher < ReekGrapher
    def graph!
      legend = @reek_count.keys.sort
      data = ""
      legend.each do |name|
        data += "g.data('#{name}', [#{@reek_count[name].join(',')}])\n"
      end
      content = <<-EOS
        #{BLUFF_DEFAULT_OPTIONS}
        g.title = 'Reek: code smells';
        #{data}
        g.labels = #{@labels.to_json};
        g.draw();
      EOS
      File.open(File.join(MetricFu.output_directory, 'reek.js'), 'w') {|f| f << content }
    end
  end
end
