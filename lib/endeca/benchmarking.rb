module Endeca
  module Benchmarking
    # Log and benchmark the workings of a single block. Will only be called if
    # Endeca.debug and Endeca.benchmark are true.
    def bm(metric_symbol, detail = nil)
      if Endeca.analyze?
        result = nil
        ms = ::Benchmark.ms { result = yield }
        add_bm_detail(metric_symbol,ms,detail) if detail.to_s.strip.length > 0
        increase_metric(metric_symbol, ms)
        Endeca.logger.debug("#{metric_symbol.to_s}: #{'%.1f' % ms}ms")
        result
      else
        yield
      end
    end

    def increase_metric(metric_symbol, up_value)
      if Endeca.analyze?
        Thread.current[:endeca] ||= {}
        Thread.current[:endeca][metric_symbol] ||= 0
        Thread.current[:endeca][metric_symbol] += up_value
      end
    end

    private

    def add_bm_detail(label,time,detail)
      if Endeca.analyze?
        Thread.current[:endeca] ||= {}
        Thread.current[:endeca]["#{label}_detail"] ||= []
        Thread.current[:endeca]["#{label}_detail"] << {:detail => detail, :time => time} 
      end
    end
  end
end
