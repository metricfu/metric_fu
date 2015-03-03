module MetricFu
  module Calculate
    module_function

    def integer_percent(num, total)
      return 0 if total.zero?
      (Float(num) / Float(total) * 100).round
    end
  end
end
