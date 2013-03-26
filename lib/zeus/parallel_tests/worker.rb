require_relative '../parallel_tests'
require 'tempfile'

module Zeus::ParallelTests
  class Worker
    def initialize(suite, env, argv)
      @env = env
      @argv = argv
      @suite = suite
    end

    def call
      system %{zeus parallel_#{@suite}_worker #{parallel_tests_attributes}}
      args_file.unlink
      $?.to_i
    end

    private

    def parallel_tests_attributes
      [test_env_number.to_s,
       @env['PARALLEL_TEST_GROUPS'],
       args_file.path].join(' ')
    end

    def args_file
      @args_file ||= begin
                       Tempfile.new("rspec_args").tap do |file|
                         @argv.each do |arg|
                           file.puts arg
                         end
                         file.close
                       end
                     end
    end

    def test_env_number
      @env['TEST_ENV_NUMBER'] != "" && @env['TEST_ENV_NUMBER'] || 1
    end
  end
end

if $PROGRAM_NAME == __FILE__
  argv = ARGV.dup
  exit Zeus::ParallelTests::Worker.new argv.shift, argv
end

