require 'benchmark'

module Endeca
  module Benchmarking
    # Log and benchmark the workings of a single block. Will only be called if
    # Endeca.debug and Endeca.benchmark are true.
    def benchmark(title)
      if Endeca.debug && Endeca.logger && Endeca.benchmark
        result = nil
        ms = ::Benchmark.ms { result = yield }
        Endeca.logger.debug("#{title}#{'%.1f' % ms}ms")
        result
      else
        yield
      end
    end
    alias_method :bm, :benchmark
  end
end
