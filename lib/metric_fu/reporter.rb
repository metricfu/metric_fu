module MetricFu
  class Reporter
    def initialize(formatters = nil)
      @formatters = Array(formatters)
    end

    def start
      notify :start
    end

    def finish
      notify :finish
    end

    def start_metric(metric)
      mf_log "** STARTING METRIC #{metric}"
      notify :start_metric, metric
    end

    def finish_metric(metric)
      mf_log "** ENDING METRIC #{metric}"
      notify :finish_metric, metric
    end

    def display_results
      notify :display_results
    end

    protected

    def notify(event, *args)
      @formatters.each do |formatter|
        formatter.send(event, *args) if formatter.respond_to?(event)
      end
    end
  end
end
