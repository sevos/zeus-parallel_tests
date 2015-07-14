describe 'Configuration file generation' do
  let(:project_dir) { File.expand_path(Dir.mktmpdir) }
  let(:bin) { File.expand_path('../../bin/zeus-parallel_tests', __FILE__) }

  subject { system(bin, 'init', chdir: project_dir) }

  after { FileUtils.rm_rf project_dir }

  it 'creates zeus configuration projects directory' do
    subject

    ['zeus.json', 'custom_plan.rb'].each do |f|
      expect(File.exist?(File.join(project_dir, f))).to be_truthy
    end
  end
end
