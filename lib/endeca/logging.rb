module Endeca
  module Logging
    # Log and benchmark the workings of a single block. Will only be called if
    # Endeca.benchmark is true
    def log(message)
      Endeca.logger.debug(message) if Endeca.debug && Endeca.logger
    end
  end
end
