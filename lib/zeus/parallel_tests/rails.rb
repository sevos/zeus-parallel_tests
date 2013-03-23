module Zeus
  module ParallelTests
    #class Rails < ::Zeus::Rails
      #def parallel_rspec
        #argv = ARGV.dup
        #test_env_number = nil
        #if argv.first =~ /test_env_number=(\d+)/
          #test_env_number = $1
          ## Parallels spec reuse main test db instead of db with "1" appended
          #test_env_number = nil if test_env_number == "1"

          #return unless defined?(ActiveRecord::Base)
          #begin
            #ActiveRecord::Base.clear_all_connections!

            #config = ActiveRecord::Base.connection_config
            #config[:database] = "#{config[:database]}#{test_env_number}"

            #ActiveRecord::Base.establish_connection(config)
            #if ActiveRecord::Base.respond_to?(:shared_connection)
              #ActiveRecord::Base.shared_connection = ActiveRecord::Base.retrieve_connection
            #end
          #rescue ActiveRecord::AdapterNotSpecified
          #end
        #end

        #argv.shift

        #ENV['TEST_ENV_NUMBER'] = test_env_number
        #ENV['PARALLEL_TEST_GROUPS'] = argv.shift

        #test_files = File.readlines("tmp/parallel_args.#{test_env_number || "1"}.tmp").map(&:chomp)

        #test(test_files.unshift("--colour").unshift("--tty"))
      #end
    #end
  end
end
