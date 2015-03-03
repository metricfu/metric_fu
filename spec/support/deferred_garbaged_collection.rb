class DeferredGarbageCollection
  DEFERRED_GC_THRESHOLD = (ENV["DEFER_GC"] || 15.0).to_f

  @@last_gc_run = Time.now

  def self.start
    GC.disable if DEFERRED_GC_THRESHOLD > 0
  end

  def self.reconsider
    if DEFERRED_GC_THRESHOLD > 0 && Time.now - @@last_gc_run >= DEFERRED_GC_THRESHOLD
      GC.enable
      GC.start
      GC.disable
      @@last_gc_run = Time.now
    end
  end

  def self.configure(config)
    return if defined?(JRUBY_VERSION)
    config.before(:all) do
      DeferredGarbageCollection.start
    end

    config.after(:all) do
      DeferredGarbageCollection.reconsider
    end
  end
end

RSpec.configure do |config|
  DeferredGarbageCollection.configure(config)
end
