require 'curb'
require 'yajl'
require 'logger'

$:.unshift(File.dirname(__FILE__))
require 'core_ext'
require 'endeca/logging'
require 'endeca/benchmarking'
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


module Endeca
  extend Benchmarking
  extend Logging

  # :stopdoc:
  VERSION = '1.4.2'
  # :startdoc:

  # Returns the version string for the library.
  def self.version
    VERSION
  end

  # Set Endeca.debug = true to turn on query logging
  # Set Endeca.benchmark = true to turn on query benchmarking
  class << self
    attr_accessor :logger
    attr_accessor :debug
    attr_accessor :benchmark
    attr_accessor :timeout

    def analyze?
      debug && logger && benchmark
    end

  end

  self.logger = Logger.new(STDOUT)
  self.debug  = false
  self.benchmark  = false
  self.timeout = 8

  # Endeca URIs require colons to be escaped
  def self.escape(str)
    URI.escape(str, /[^-_.!~*'()a-zA-Z\d;\/?@&=+$,\[\]]/n)
  end
end

puts ">> Using Endeca gem version: #{Endeca::VERSION}"
