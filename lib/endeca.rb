require 'curb'
require 'yajl'
require 'logger'
require 'uri'

$:.unshift(File.dirname(__FILE__))
require 'core_ext'
require 'endeca/logging'
require 'endeca/benchmarking'

module Endeca
  extend Benchmarking
  extend Logging

  # :stopdoc:
  VERSION = '1.5.0'
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
  self.timeout = 8

  # Endeca URIs require colons to be escaped
  def self.escape(str)
    URI.escape(str, /[^-_.!~*'()a-zA-Z\d;\/?@&=+$,\[\]]/n)
  end
end

require 'endeca/readers'
require 'endeca/map'
require 'endeca/transformer'
require 'endeca/dimension'
require 'endeca/refinement_dimension'
require 'endeca/refinement'
require 'endeca/breadcrumbs'
require 'endeca/breadcrumb'
require 'endeca/request'
require 'endeca/document_collection'
require 'endeca/document'

puts ">> Using Endeca gem version: #{Endeca::VERSION}"
