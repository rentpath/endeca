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

task :default => 'spec:run'

PROJ.name = 'endeca'
PROJ.authors = ['Rein Henrichs', 'Andy Stone']
PROJ.email = ''
PROJ.url = 'http://github.com/primedia/endeca-ruby'
PROJ.version = Endeca::VERSION
PROJ.rubyforge.name = 'endeca-ruby'

# EOF
