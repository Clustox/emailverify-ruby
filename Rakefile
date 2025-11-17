require "rake/testtask"
require "rspec/core/rake_task"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = Dir["spec/**/*_spec.rb"]
end

RSpec::Core::RakeTask.new(:spec)

task default: :spec
