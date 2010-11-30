require 'rubygems'

require File.join(File.dirname(__FILE__),'lib', 'endeca')

desire('rake')
desire('rcov')
desire('spec/rake/spectask')

task :default => 'rcov'

desc "Simple benchmarking"
task :benchmark do
  sh('ruby example/benchmark.rb')
end
task :bm => :benchmark

desc "Flog your code for Justice!"
task :flog do
  sh('flog lib/**/*.rb')
end

desc "Run all specs and rcov in a non-sucky way"
Spec::Rake::SpecTask.new(:rcov) do |t|
  $: << File.join(File.dirname(__FILE__), 'spec')
  t.spec_opts = IO.readlines("spec/spec.opts").map {|l| l.chomp.split " "}.flatten
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = IO.readlines("spec/rcov.opts").map {|l| l.chomp.split " "}.flatten
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "endeca"
    gemspec.version = Endeca.version
    gemspec.summary = "Endeca adapter for use with the Endeca Bridge"
    gemspec.email = ""
    gemspec.homepage = 'http://github.com/primedia/endeca-ruby'
    gemspec.authors = ["Primedia Team"]
    gemspec.add_dependency('curb','=0.6.6.0')
    gemspec.add_dependency('yajl-ruby','=0.7.1')
    gemspec.add_development_dependency('rspec')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
