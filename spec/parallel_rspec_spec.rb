$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)

require 'zeus/parallel_tests/version'
require 'open3'

describe 'zeus parallel_rspec spec' do
  def launch_server
    pid = fork do
      Dir.chdir 'spec/dummy/' do
        exec 'bundle exec zeus start &>/dev/null'
      end
    end
    sleep 3
    pid
  end

  before(:all) do
    # Copy current Appraisal gemfile to dummy app.
    gemfile = File.read(ENV['BUNDLE_GEMFILE']).gsub(':path => "../"', ':path => "../../"')
    File.open('spec/dummy/Gemfile', 'w+') { |f| f.write gemfile }
    gemfile_lock = File.read("#{ENV['BUNDLE_GEMFILE']}.lock").gsub('remote: ../', 'remote: ../../')
    File.open('spec/dummy/Gemfile.lock', 'w+') { |f| f.write gemfile_lock }

    # Launch Zeus.
    @server_pid = launch_server.to_s
  end

  it 'connects to server' do
    Dir.chdir 'spec/dummy/' do
      system('bundle', 'exec', 'zeus', 'r', 'true')
      expect($?.exitstatus).to eq(0)
    end
  end

  it 'runs specs in two processes' do
    Dir.chdir 'spec/dummy' do
      Open3.popen2e('bundle', 'exec', 'zeus', 'parallel_rspec', '-n', '2', 'spec') do |_, output|
        expect(output.to_a.map(&:chomp)).to include('2 processes for 2 specs, ~ 1 specs per process')
      end
    end
  end

  after(:all) do
    system('kill', '-9', @server_pid)
    system('rm', '-f', 'spec/dummy/Gemfile', 'spec/dummy/Gemfile.lock')
  end
end
