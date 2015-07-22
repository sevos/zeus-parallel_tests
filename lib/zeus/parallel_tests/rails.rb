require_relative '../parallel_tests'
require_relative 'worker'

# Patches required for parallel_tests

module ParallelTests
  module Tasks
    class << self
      def rails_env
        # parallel_tests sets this to 'test' by default - this must be
        # overridden because Zeus does not support $RAILS_ENV being set
        nil
      end
    end
  end
end

# End of patches for parallel_test

module Zeus
  module ParallelTests
    class Rails < ::Zeus::Rails
      def parallel_cucumber
        if ENV.key?('RAILS_ENV')
          puts "Warning: Deleting RAILS_ENV (which is `#{ENV['RAILS_ENV']}` as Zeus will complain about it."
          ENV.delete('RAILS_ENV')
        end
        exec parallel_runner_command 'cucumber', ARGV
      end

      def parallel_rspec
        if ENV.key?('RAILS_ENV')
          puts "Warning: Deleting RAILS_ENV (which is `#{ENV['RAILS_ENV']}` as Zeus will complain about it."
          ENV.delete('RAILS_ENV')
        end
        argv = ARGV.dup
        argv.delete('--color')  # remove this argument from list
        argv.delete('--colour') # because it was causing bug #14
        exec parallel_runner_command 'rspec', argv
      end

      def parallel_cucumber_worker
        spawn_slave { |args| cucumber(args) }
      end

      def parallel_rspec_worker
        spawn_slave { |args| test(args) }
      end

      # Patches required in Zeus

      def test(argv = ARGV)
        if spec_file?(argv) && defined?(RSpec)
          # disable autorun in case the user left it in spec_helper.rb
          RSpec::Core::Runner.disable_autorun!
          exit RSpec::Core::Runner.run(argv)
        else
          Zeus::M.run(argv)
        end
      end

      def cucumber_environment
        require 'cucumber/rspec/disable_option_parser'
        require 'cucumber/cli/main'
      end

      def cucumber(argv = ARGV)
        ::Cucumber::Cli::Main.execute(argv)
      end

      # End of patches for Zeus

      private

      def parallel_runner_command(suite, argv)
        env_slave_path = %(PARALLEL_TESTS_EXECUTABLE='#{Worker.command suite}')
        "#{env_slave_path} parallel_#{suite} #{merge_argv(argv)}"
      end

      def merge_argv(argv)
        argv.map do |arg|
          arg.include?(' ') ? %("#{arg}") : arg
        end.join(' ')
      end

      def spawn_slave
        worker, workers_count, args_file = ARGV
        # Parallels spec reuse main test db instead of db with "1" appended
        ENV['TEST_ENV_NUMBER'] = test_env_number = (worker == '1' ? nil : worker)
        ENV['PARALLEL_TEST_GROUPS'] = workers_count

        reconfigure_activerecord test_env_number

        yield load_args_from_file(args_file)
      end

      def load_args_from_file(path)
        File.readlines(path).map(&:chomp)
      end

      # rubocop:disable HandleExceptions
      def reconfigure_activerecord(test_env_number)
        return unless defined?(ActiveRecord::Base)
        begin
          ActiveRecord::Base.clear_all_connections!

          config = ActiveRecord::Base.connection_config
          config[:database] = "#{config[:database]}#{test_env_number}"

          ActiveRecord::Base.establish_connection(config)
          if ActiveRecord::Base.respond_to?(:shared_connection)
            ActiveRecord::Base.shared_connection = ActiveRecord::Base.retrieve_connection
          end
        rescue ActiveRecord::AdapterNotSpecified
        end
      end
      # rubocop:enable HandleExceptions
    end
  end
end
