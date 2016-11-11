require './lib/zeus/parallel_tests/worker'

describe Zeus::ParallelTests::Worker do
  describe '.run' do
    let(:cli_argv) { ['rspec', 'spec/models/model_spec.rb'] }
    let(:cli_env)  { { 'TEST_ENV_NUMBER' => '3' } }
    let(:worker)   { double('worker', spawn: 0) }
    before  { allow(Zeus::ParallelTests::Worker).to receive_messages(new: worker) }
    subject { Zeus::ParallelTests::Worker.run(cli_argv, cli_env)  }

    it 'creates instance of worker' do
      expect(Zeus::ParallelTests::Worker).to receive(:new)
        .with('rspec', cli_env, ['spec/models/model_spec.rb'])
        .and_return(worker)
      subject
    end

    it 'does not modify original env and argv' do
      subject
      expect(cli_argv).to eq(['rspec', 'spec/models/model_spec.rb'])
      expect(cli_env).to eq('TEST_ENV_NUMBER' => '3')
    end

    it 'returns exit code' do
      expect(subject).to eq(0)
    end
  end

  describe '#spawn' do
    subject { worker.spawn }
    let(:worker) { Zeus::ParallelTests::Worker.new('rspec', cli_env, ['spec/file_spec.rb']) }
    let(:cli_env) { { 'TEST_ENV_NUMBER' => 2, 'PARALLEL_TEST_GROUPS' => 4 } }
    let(:argv_file) { double('argv_file', path: 'argv_file_path', unlink: true, puts: nil, close: nil) }
    before do
      allow(Tempfile).to receive_messages(new: argv_file)
      allow(worker).to receive_messages(system: true)
    end

    it 'writes args to file' do
      expect(argv_file).to receive(:puts).with('spec/file_spec.rb')
      subject
    end

    it 'spawns worker and passes TEST_ENV_NUMBER, PARALLEL_TEST_GROUPS and argv file path' do
      expect(worker).to receive(:system).with('zeus parallel_rspec_worker 2 4 argv_file_path')
      subject
    end

    it 'removes argv_file after run' do
      expect(argv_file).to receive(:unlink)
      subject
    end

    it 'returns exit code' do
      system 'true'
      expect(worker).to receive(:system) { allow($CHILD_STATUS).to receive_messages(exitstatus: 1) }
      expect(subject).to eq(1)
    end
  end
end
