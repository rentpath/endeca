# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{endeca}
  s.version = "0.9.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rein Henrichs", "Andy Stone"]
  s.date = %q{2009-01-27}
  s.description = %q{An Endeca client library for Ruby.}
  s.email = %q{}
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "example/benchmark.rb", "example/listing.rb", "lib/class_to_proc.rb", "lib/core_ext.rb", "lib/endeca.rb", "lib/endeca/dimension.rb", "lib/endeca/document.rb", "lib/endeca/document_collection.rb", "lib/endeca/map.rb", "lib/endeca/readers.rb", "lib/endeca/refinement.rb", "lib/endeca/request.rb", "lib/endeca/transformer.rb", "spec/core_ext_spec.rb", "spec/endeca/dimension_spec.rb", "spec/endeca/document_collection_spec.rb", "spec/endeca/document_spec.rb", "spec/endeca/map_spec.rb", "spec/endeca/readers_spec.rb", "spec/endeca/refinement_spec.rb", "spec/endeca/request_spec.rb", "spec/endeca/transformer_spec.rb", "spec/endeca_spec.rb", "spec/rcov.opts", "spec/spec.opts", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/primedia/endeca-ruby}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{endeca-ruby}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{An Endeca client library for Ruby}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bones>, [">= 2.3.0"])
    else
      s.add_dependency(%q<bones>, [">= 2.3.0"])
    end
  else
    s.add_dependency(%q<bones>, [">= 2.3.0"])
  end
end
