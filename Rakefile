# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'endeca'

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
  t.spec_opts = IO.readlines("spec/spec.opts").map {|l| l.chomp.split " "}.flatten
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = IO.readlines("spec/rcov.opts").map {|l| l.chomp.split " "}.flatten
end

PROJ.name = 'endeca'
PROJ.authors = ['Rein Henrichs', 'Andy Stone']
PROJ.email = ''
PROJ.url = 'http://github.com/primedia/endeca-ruby'
PROJ.version = Endeca::VERSION
PROJ.rubyforge.name = 'endeca-ruby'
PROJ.readme_file = "README.rdoc"

# EOF
