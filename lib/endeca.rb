$:.unshift(File.dirname(__FILE__))
require 'net/http'
require 'json'
require 'core_ext'
require 'class_to_proc'
require 'endeca/document_collection'
require 'endeca/readers'
require 'endeca/dimension'
require 'endeca/refinement'
require 'endeca/request'
require 'endeca/document'

module Endeca

  # :stopdoc:
  VERSION = '0.0.1'
  # :startdoc:

  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end
end
