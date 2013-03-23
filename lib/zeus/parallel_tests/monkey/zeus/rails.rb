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
