require 'rubygems'
require 'hoe'
require './lib/git_trip.rb'

APP_ROOT = File.dirname(__FILE__) unless defined?(APP_ROOT)

task :default => [ :spec ]

Hoe.new('git-trip', GitTrip::VERSION) do |p|
  p.developer('Dale Campbell', 'dale@save-state.net')
end

FileList['tasks/**/*.rake'].sort.each { |task| load task }

# Remove un-needed tasks.
remove_task 'audit'
remove_task 'generate_key'
remove_task 'multi'
remove_task 'post_blog'
remove_task 'test'
remove_task 'test_deps'

desc 'Start an irb session with Ridge loaded'
task :console do
  sh "irb -d -I ./lib -r 'git_trip'"
end
