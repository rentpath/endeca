require 'benchmark'

module Endeca
  module Benchmarking
    # Log and benchmark the workings of a single block. Will only be called if
    # Endeca.debug and Endeca.benchmark are true.
    def bm(title)
      if Endeca.debug && Endeca.logger && Endeca.benchmark
        result = nil
        ms = ::Benchmark.ms { result = yield }
        Endeca.logger.debug("#{title}#{'%.1f' % ms}ms")
        result
      else
        yield
      end
    end
  end
end
