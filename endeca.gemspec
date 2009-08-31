# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{endeca}
  s.version = "1.3.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rein Henrichs", "Andy Stone"]
  s.date = %q{2009-08-31}
  s.description = %q{An Endeca client library for Ruby.}
  s.email = %q{}
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "endeca.gemspec", "example/benchmark.rb", "example/listing.rb", "lib/class_to_proc.rb", "lib/core_ext.rb", "lib/endeca.rb", "lib/endeca/benchmarking.rb", "lib/endeca/breadcrumb.rb", "lib/endeca/breadcrumbs.rb", "lib/endeca/caching.rb", "lib/endeca/dimension.rb", "lib/endeca/document.rb", "lib/endeca/document_collection.rb", "lib/endeca/logging.rb", "lib/endeca/map.rb", "lib/endeca/readers.rb", "lib/endeca/refinement.rb", "lib/endeca/refinement_dimension.rb", "lib/endeca/request.rb", "lib/endeca/transformer.rb", "spec/core_ext_spec.rb", "spec/endeca/benchmarking_spec.rb", "spec/endeca/breadcrumb_spec.rb", "spec/endeca/caching_spec.rb", "spec/endeca/dimension_spec.rb", "spec/endeca/document_collection_spec.rb", "spec/endeca/document_spec.rb", "spec/endeca/map_spec.rb", "spec/endeca/readers_spec.rb", "spec/endeca/refinement_dimension_spec.rb", "spec/endeca/refinement_spec.rb", "spec/endeca/request_spec.rb", "spec/endeca/transformer_spec.rb", "spec/endeca_spec.rb", "spec/rcov.opts", "spec/spec.opts", "spec/spec_helper.rb"]
  s.homepage = %q{http://github.com/primedia/endeca-ruby}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{endeca}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{An Endeca client library for Ruby}
end
