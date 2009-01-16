require 'benchmark'

$:.unshift(File.expand_path(File.dirname(__FILE__)))
require 'lib/endeca'
require 'listing'

RUNS = 10
Benchmark.bmbm do |results|
  results.report('Full Request') {RUNS.times{Listing.all}}
  results.report('Parse JSON') {RUNS.times{Endeca::Request.perform(Listing.get_path,'')}}
  results.report('Get Net Response') {RUNS.times{Endeca::Request.new(Listing.get_path,'').send(:get_response)}}
end

