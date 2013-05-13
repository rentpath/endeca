require 'curb'
require 'yajl'
require 'logger'
require 'uri'

$:.unshift(File.dirname(__FILE__))
require_relative 'core_ext'
require_relative 'endeca/logging'
require_relative 'endeca/benchmarking'

module Endeca
  extend Benchmarking
  extend Logging

  # :stopdoc:
  VERSION = '1.6.1'
  # :startdoc:

  # Returns the version string for the library.
  def self.version
    VERSION
  end

  # Set ENV['ENDECA_DEBUG'] = true to turn on query logging
  # Set ENV['ENDECA_BENCHMARK'] = true to turn on query benchmarking
  class << self
    attr_accessor :logger
    attr_accessor :timeout

    def debug?
      ENV['ENDECA_DEBUG'] == 'true'
    end

    def benchmark?
      ENV['ENDECA_BENCHMARK'] == 'true'
    end

  end

  self.logger = Logger.new(STDOUT)

  # Number of seconds until connection should time out.
  self.timeout = 2

  # Endeca URIs require colons to be escaped
  def self.escape(str)
    URI.escape(str, /[^-_.!~*'()a-zA-Z\d;\/?@&=+$,\[\]]/n)
  end
end

require_relative 'endeca/readers'
require_relative 'endeca/map'
require_relative 'endeca/transformer'
require_relative 'endeca/dimension'
require_relative 'endeca/refinement_dimension'
require_relative 'endeca/refinement'
require_relative 'endeca/breadcrumbs'
require_relative 'endeca/breadcrumb'
require_relative 'endeca/request'
require_relative 'endeca/document_collection'
require_relative 'endeca/document'

puts ">> Using Endeca gem version: #{Endeca::VERSION}"
