require 'spec_helper'

$:.unshift File.expand_path("../../../lib", __FILE__)

require "zeus/parallel_tests/version"
require 'open3'

describe "zeus parallel_rspec spec" do
  def build_gem(version=Zeus::ParallelTests::VERSION)
    system "gem build zeus-parallel_tests.gemspec &>/dev/null"
  end

  def install_gem(version=Zeus::ParallelTests::VERSION)
    system "gem install ./zeus-parallel_tests-#{version}.gem --ignore-dependencies &>/dev/null"
  end

  def uninstall_gem(version=Zeus::ParallelTests::VERSION)
    system "echo y | gem uninstall zeus-parallel_tests -v #{version} --quiet &>/dev/null"
  end

  def launch_server
    pid = fork do
      Dir.chdir "spec/dummy/"
      system "bundle install"
      exec "bundle exec zeus start &>/dev/null"
    end
    sleep 3
    pid
  end

  before(:all) do
    build_gem
    install_gem
    print "Launch zeus server for dummy app in separate console and press ENTER "
    $stdin.getc
    # @server_pid = launch_server.to_i
    Dir.chdir "spec/dummy/"
  end

  it "connects to server" do
    expect(system("zeus r true &>/dev/null")).to be_true
  end

  it 'runs specs in two processes' do
    Open3.popen2e("zeus", "parallel_rspec", "-n", "2", "spec") do |input, output, t|
      expect(output.to_a.map(&:chomp)).to include("2 processes for 2 specs, ~ 1 specs per process")
    end
  end

  after(:all) do
    # system "kill -9 #{@server_pid.to_s}"
    # system "rm -fr .zeus.sock"
    uninstall_gem
  end
end

