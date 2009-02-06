require 'rubygems'
require 'net/http'
require 'json'
require 'logger'
require 'activesupport'

$:.unshift(File.dirname(__FILE__))
require 'core_ext'
require 'class_to_proc'
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

  # :stopdoc:
  VERSION = '0.9.17'
  # :startdoc:

  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end

  # Set Endeca.debug = true to turn on query logging
  class << self
    attr_accessor :debug
    attr_accessor :logger
  end

  self.debug  = false
  self.logger = Logger.new(STDOUT)
end
