require 'digest/sha1'

require 'rubygems'
require 'active_support/core_ext/module/aliasing'
require 'active_support/core_ext/array'
require 'active_support/core_ext/class'
require 'active_support/cache'
require 'endeca'

module Endeca #:nodoc:

  class << self
    def perform_caching?; !@@cache_store.nil? end
    def cache_store;      @@cache_store;      end

    # Defines the storage option for cached queries
    def cache_store=(store_option)
      @@cache_store = ActiveSupport::Cache.lookup_store(store_option)
    end
  end

  # Caching is a way to speed up slow Endeca queries by keeping the result of
  # an Endeca request around to be reused by subequest requests. Caching is
  # turned off by default.
  #
  # Note: To ensure that caching is turned off, set Endeca.cache_store = nil
  #
  # == Caching stores
  #
  # All the caching stores from ActiveSupport::Cache are available to be used
  # as backends for Endeca caching. See the Rails rdoc for more information on
  # these stores
  #
  # Configuration examples (MemoryStore is the default):
  #
  #   Endeca.cache_store = :memory_store
  #   Endeca.cache_store = :file_store, "/path/to/cache/directory"
  #   Endeca.cache_store = :drb_store, "druby://localhost:9192"
  #   Endeca.cache_store = :mem_cache_store, "localhost"
  #   Endeca.cache_store = MyOwnStore.new("parameter")
  module Caching    
    def self.included(base)
      base.alias_method_chain :get_response, :caching
    end

    private

    def get_response_with_caching #:nodoc:
      return get_response_without_caching unless Endeca.perform_caching?
      fetch { get_response_without_caching }
    end

    def cache_key;     Digest::SHA1.hexdigest uri.to_s end
    def fetch(&block); Endeca.cache_store.fetch(cache_key, &block) end
  end
end