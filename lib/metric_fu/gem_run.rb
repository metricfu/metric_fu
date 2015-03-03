# encoding: utf-8
require "open3"
require "shellwords"
require "metric_fu"
MetricFu.lib_require { "logger" }
MetricFu.lib_require { "gem_version" }
module MetricFu
  class GemRun
    attr_reader :output, :gem_name, :library_name, :version, :arguments
    def initialize(arguments = {})
      @gem_name    = arguments.fetch(:gem_name)
      @library_name = arguments.fetch(:metric_name)
      @version = arguments.fetch(:version) { MetricFu::GemVersion.for(library_name) }
      args = arguments.fetch(:args)
      @arguments = args.respond_to?(:scan) ? Shellwords.shellwords(args) : args
      @output = ""
      @errors = []
    end

    def summary
      "RubyGem #{gem_name}, library #{library_name}, version #{version}, arguments #{arguments}"
    end

    def run
      @output = execute
    end

    def execute
      mf_debug "Running #{summary}"
      captured_output = ""
      captured_errors = ""
      thread = ""
      Open3.popen3("#{library_name}", *arguments) do |_stdin, stdout, stderr, wait_thr|
        captured_output << stdout.read.chomp
        captured_errors << stderr.read.chomp
        thread = wait_thr
      end
    rescue StandardError => run_error
      handle_run_error(run_error)
    rescue SystemExit => system_exit
      handle_system_exit(system_exit)
    ensure
      print_errors
      return captured_output, captured_errors, thread.value
    end

    def handle_run_error(run_error)
      @errors << "ERROR: #{run_error.inspect}"
    end

    def handle_system_exit(system_exit)
      status =  system_exit.success? ? "SUCCESS" : "FAILURE"
      message = "#{status} with code #{system_exit.status}: " <<
                "#{system_exit.message}: #{system_exit.backtrace.inspect}"
      if status == "SUCCESS"
        mf_debug message
      else
        @errors << message
      end
    end

    def print_errors
      return if @errors.empty?
      STDERR.puts "ERRORS running #{summary}"
      @errors.each do |error|
        STDERR.puts "\t" << error
      end
    end
  end
end
