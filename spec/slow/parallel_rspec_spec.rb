$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)

require 'zeus/parallel_tests/version'
require 'open3'

describe 'zeus parallel_rspec spec' do
  def launch_server
    pid = fork do
      Dir.chdir 'spec/dummy/' do
        exec 'bundle exec zeus --log zeus.log start &>/dev/null'
      end
    end
    sleep 3
    pid
  end

  before(:all) do
    @server_pid = launch_server
    Dir.chdir 'spec/dummy/'
  end

  it 'connects to server' do
    expect(system('zeus r true &>/dev/null')).to be_truthy
  end

  it 'runs specs in two processes' do
    Open3.popen2e('zeus', 'parallel_rspec', '-n', '2', 'spec') do |_input, output, _t|
      expect(output.to_a.map(&:chomp)).to include('2 processes for 2 specs, ~ 1 specs per process')
    end
  end

  after(:all) do
    system('kill', '-9', @server_pid)
    system('rm', '-f', '.zeus.sock')
  end
end
