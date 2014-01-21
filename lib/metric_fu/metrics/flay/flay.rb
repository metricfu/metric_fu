module MetricFu

  class FlayGenerator < Generator

    def self.metric
      :flay
    end

    def emit
      minimum_score_parameter = options[:minimum_score] ? "--mass #{options[:minimum_score]} " : ""
      diff_parameter = options[:diff] ? "--diff " : ""
      args =  "#{minimum_score_parameter} #{diff_parameter} #{options[:dirs_to_flay].join(" ")}"
      @output = run!(args)
    end

    def analyze
      if options[:diff].nil?
        @matches = @output.chomp.split("\n\n").map{|m| m.split("\n  ") }
      else
        @output = @output.encode!('UTF-8', 'ISO-8859-1', :invalid => :replace)
        problems = @output.chomp.split(/(?=\n\n\d+\))/)
      
        @matches = Array.new
        data = Array.new
        data.push(problems.shift)
        @matches.push(data)
      
        problems.each do |problem|
          data = Array.new
          parts = problem.strip.split("\n", 2)
          data.push(parts[0])
      
          pieces = parts[1].split("\n\n", 2)
          files = pieces[0]
          diffs = pieces[1]
      
          file_hash = Hash[files.scan(/\s+(\S+):\s+(\S+)/).map { |(key, value)| [key, value] }]
          count_hash = Hash[file_hash.values.map { |key| [key, 0] }]
      
          all = 0
          if diffs.nil?
            # No lines in diff, must match on that line exactly.
            all = 1
          else
            diffs.split("\n").each do |line|
              key = line.match(/^(\S+):/)
              if key.nil?
                  all += 1
              else
                  count_hash[file_hash[key[1]]] += 1
              end
            end
          end
      
          count_hash.each do |key, value|
            count_hash[key] += all
          end
      
          count_hash.each do |key, value|
            data.push(key + ":" + value.to_s)
          end
      
          @matches.push(data)
        end
      end
    end

    def to_h
      target = []
      total_score = @matches.shift.first.split('=').last.strip
      @matches.each do |problem|
        reason = problem.shift.strip
        lines_info = problem.map do |full_line|
          name, line, number = full_line.split(":")
          if number.nil?
            {:name => name.strip, :line => line.strip}
          else 
            {:name => name.strip, :start => line.strip, :lines => number.strip}
          end
        end
        target << [:reason => reason, :matches => lines_info]
      end
      {:flay => {:total_score => total_score, :matches => target.flatten}}
    end
  end
end
