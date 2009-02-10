require 'rubygems'
require 'net/http'
require 'json'
require 'logger'
require 'activesupport'

$:.unshift(File.dirname(__FILE__))
require 'core_ext'
require 'class_to_proc'
require 'endeca/logging'
require 'endeca/benchmarking'
require 'endeca/readers'
require 'endeca/map'
require 'endeca/transformer'
require 'endeca/dimension'
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
  VERSION = '0.9.21'
  # :startdoc:

  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end

  # Set Endeca.debug = true to turn on query logging
  class << self
    attr_accessor :logger
    attr_accessor :debug
    attr_accessor :benchmark
  end

  self.logger = Logger.new(STDOUT)
  self.debug  = false
  self.benchmark  = false
  
  # Endeca URIs require colons to be escaped
  def self.escape(str)
    URI.escape(str, /[^-_.!~*'()a-zA-Z\d;\/?@&=+$,\[\]]/n)
  end
end
