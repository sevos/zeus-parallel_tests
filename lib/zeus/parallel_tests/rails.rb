require_relative '../parallel_tests'
require_relative 'worker'

module Zeus
  module ParallelTests
    class Rails < ::Zeus::Rails
      def parallel_cucumber
        exec parallel_runner_command "cucumber", ARGV
      end

      def parallel_rspec
        exec parallel_runner_command "rspec", ARGV
      end

      def parallel_cucumber_worker
        argv = ARGV.dup
        test_env_number = argv.shift
        # Parallels spec reuse main test db instead of db with "1" appended
        test_env_number = nil if test_env_number == "1"

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

        ENV['TEST_ENV_NUMBER'] = test_env_number
        ENV['PARALLEL_TEST_GROUPS'] = argv.shift

        rspec_args_file = argv.shift
        test_files = File.readlines(rspec_args_file).map(&:chomp)

        cucumber(test_files)
      end

      def parallel_rspec_worker
        argv = ARGV.dup
        test_env_number = argv.shift
        # Parallels spec reuse main test db instead of db with "1" appended
        test_env_number = nil if test_env_number == "1"

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

        ENV['TEST_ENV_NUMBER'] = test_env_number
        ENV['PARALLEL_TEST_GROUPS'] = argv.shift

        rspec_args_file = argv.shift
        test_files = File.readlines(rspec_args_file).map(&:chomp)

        test(test_files.unshift("--colour").unshift("--tty"))
      end

      def test(argv = ARGV)
        if spec_file?(argv) && defined?(RSpec)
          # disable autorun in case the user left it in spec_helper.rb
          RSpec::Core::Runner.disable_autorun!
          exit RSpec::Core::Runner.run(argv)
        else
          Zeus::M.run(argv)
        end
      end

      def cucumber(argv = ARGV)
        cucumber_main = Cucumber::Cli::Main.new(argv.dup)
        had_failures = cucumber_main.execute!(@cucumber_runtime)
        exit_code = had_failures ? 1 : 0
        exit exit_code
      end

      private

      def parallel_runner_command(suite, argv)
        env_slave_path = %[PARALLEL_TESTS_EXECUTABLE='#{Worker.command suite}']
        "#{env_slave_path} parallel_#{suite} #{argv.join ' '}"
      end

    end
  end
end
