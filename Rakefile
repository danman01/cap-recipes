=begin
Using Jeweler for Gem Packaging...

  * Update the version and release version to github:
    $ rake version:bump:patch && rake release && rake gemcutter:release

  * Build and install the latest version locally:
    $ rake install

=end

require 'rake'
require 'rake/testtask'
require 'rdoc'
require 'rdoc/task'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "cap-recipes"
    s.summary = %Q{Battle-tested capistrano recipes for debian based distributions}
    s.email = "nesquena@gmail.com donnoman@donovanbray.com"
    s.homepage = "http://github.com/nesquena/cap-recipes"
    s.description = "Battle-tested capistrano recipes for debian based distributions, passenger, apache, nginx, delayed_job, juggernaut, rubygems, backgroundrb, rails, riak, mongo and more"
    s.authors = ["Nathan Esquenazi","Donovan Bray"]
    s.rubyforge_project = 'cap-recipes'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'cap-recipes'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_test.rb']
    t.verbose = true
  end
rescue LoadError
end

desc "Run all specs in spec directory"
task :spec do |t|
  options = "--colour --format progress --loadby --reverse"
  files = FileList['spec/**/*_spec.rb']
  system("spec #{options} #{files}")
end

task :default => :spec