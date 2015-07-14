require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec
namespace :travis do
  RSpec::Core::RakeTask.new(:spec) do |task|
    file_list = FileList['spec/**/*_spec.rb']

    %w(slow).each do |exclude|
      file_list = file_list.exclude("spec/#{exclude}/**/*_spec.rb")
    end

    task.pattern = file_list
  end
end
