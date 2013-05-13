begin
  require 'bundler'
  Bundler::GemHelper.install_tasks
rescue Exception
end

require "rspec"
require "rspec/core/rake_task"
require 'rake/testtask'

require 'rubygems'

require File.join(File.dirname(__FILE__),'lib', 'endeca')

task :default => 'spec'


desc "Run all specs"
task :spec do |t, args|
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rspec_opts = %w(-fs --color)
  end
end

desc "Simple benchmarking"
task :benchmark do
  sh('ruby example/benchmark.rb')
end
task :bm => :benchmark

desc "Flog your code for Justice!"
task :flog do
  sh('flog lib/**/*.rb')
end

