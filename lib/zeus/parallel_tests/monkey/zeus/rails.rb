module Zeus::ParallelTests::Monkey
  module RailsTestAcceptsArgv
    def test(argv = ARGV)
      if spec_file?(argv) && defined?(RSpec)
        # disable autorun in case the user left it in spec_helper.rb
        RSpec::Core::Runner.disable_autorun!
        exit RSpec::Core::Runner.run(argv)
      else
        Zeus::M.run(argv)
      end
    end
  end
end
begin
Zeus::Rails.instance_eval do
  include Zeus::ParallelTests::Monkey::RailsTestAcceptsArgv
end
rescue => e
  File.open("/Users/sevos/Projects/plan.log", "w+") do |file|
    file.puts e.message
  end
end
