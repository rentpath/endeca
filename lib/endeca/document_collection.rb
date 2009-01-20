require 'endeca/document'
module Endeca
  # Endeca DocumentCollections wrap a collection of Endeca Documents to provide
  # access to metadata returned by the Endeca query. They behave like a simple
  # Array in most cases (e.g. iteration) but also provide access to
  # +refinements+.
  #
  # ==Attribute Readers
  #
  # DocumentCollection provides attribute readers for collection metadata in
  # an interface that is compatible with WillPaginate::Collection for use in
  # views.
  #
  # == Method Delegation
  #
  # DocumentCollections delegate array-like behavior to their embedded document
  # collection, (+documents+). In most cases a DocumentCollection can be used
  # as if it were an array of Document objects. (Array delegation pattern
  # borrowed from Rake::FileList)
  class DocumentCollection
    extend ClassToProc
    extend Readers

    attr_reader :raw
    def initialize(raw, document_klass=Document)
      @raw = raw
      @document_klass = document_klass
    end

    def attributes
      @raw['MetaInfo'] || {}
    end

    reader \
      'NextPageLink' => :next_page_params

    integer_reader \
      'NumberofPages'           => :total_pages,
      'NumberofRecordsperPage'  => :per_page,
      'PageNumber'              => :current_page,
      'TotalNumberofMatchingRecords' => :total_entries

    # WillPaginate +offset+ correspondes to Endeca StartingRecordNumber - 1
    reader('StartingRecordNumber' => :offset) {|i| Integer(i) - 1}

    # The previous page number.
    # Returns nil if there is no previous page.
    # Borrowed from WillPaginate for compatibility.
    def previous_page
      current_page > 1 ? (current_page - 1) : nil
    end

    # The next page number.
    # Returns nil if there is no next page.
    # Borrowed from WillPaginate for compatibility
    def next_page
      current_page < total_pages ? (current_page + 1) : nil
    end

    # The internal collection of Document objects. Array methods are delegated here. 
    def documents
      @documents ||= (@raw['Records'] || []).map(&@document_klass)
    end

    # The collection of Refinement objects for the collection.
    def refinements
      @refinements ||= (@raw['Refinements'] || []).map(&Refinement)
    end

    # List of array methods (that are not in +Object+) that need to be
    # delegated to +documents+.
    ARRAY_METHODS = (Array.instance_methods - Object.instance_methods).map { |n| n.to_s }

    # List of additional methods that must be delegated to +documents+.
    MUST_DEFINE = %w[to_a to_ary inspect]

    (ARRAY_METHODS + MUST_DEFINE).uniq.each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{method}(*args, &block)                 # def each(*args, &block)
          documents.send(:#{method}, *args, &block)  #   documents.send(:each, *args, &block)
        end                                          # end
      RUBY
    end

    # Lie about our class. Borrowed from Rake::FileList
    # Note: Does not work for case equality (<tt>===</tt>)
    def is_a?(klass)
      klass == Array || super(klass)
    end
    alias kind_of? is_a?

  end
end
