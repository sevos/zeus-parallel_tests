require File.expand_path('../../test_helper', __FILE__)
require 'tmpdir'
require 'fileutils'

describe 'zeus-parallel_tests' do
  before do
    @project_dir = File.expand_path(Dir.mktmpdir)
    Dir.mkdir(File.join(@project_dir, "script"))

    bin = File.expand_path('../../../bin/zeus-parallel_tests', __FILE__)
    @run = -> { system("#{bin} init &>/dev/null", chdir: @project_dir) }
  end

  after do
    FileUtils.rm_rf @project_dir
    @io && @io.close
  end

  it "creates zeus configuration and script/spec in projects directory" do
    @run.call

    expected_files = ['zeus.json', 'custom_plan.rb'].
      map { |f| File.join(@project_dir, f) }

    expected_files.each do |f|
      assert File.exists?(f), "#{f} should exists"
    end
  end
end
