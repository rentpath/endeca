require 'spec_helper'

class Logit
  include Endeca::Logging
end

describe Endeca::Logging do
  before do
    @logit = Logit.new
  end

  describe '.log' do
    it 'calls endeca logger' do
      logger = mock('logger')
      Endeca.should_receive(:debug?).and_return(true)
      Endeca.should_receive(:logger).and_return(logger)

      logger.should_receive(:debug).with('hiya')

      @logit.log('hiya')
    end
  end
end
