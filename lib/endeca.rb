require 'rubygems'
$:.unshift(File.dirname(__FILE__))
require 'net/http'
require 'json'
require 'logger'
require 'core_ext'
require 'class_to_proc'
require 'endeca/readers'
require 'endeca/map'
require 'endeca/transformer'
require 'endeca/dimension'
require 'endeca/refinement'
require 'endeca/request'
require 'endeca/document_collection'
require 'endeca/document'

module Endeca

  # :stopdoc:
  VERSION = '0.1.0'
  # :startdoc:

  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end

  class << self
    attr_accessor :debug
    attr_accessor :logger
  end

  self.debug  = false
  self.logger = Logger.new(STDOUT)
end
