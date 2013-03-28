require "spec_helper"

require_relative "../../../../lib/zeus/parallel_tests/worker"

describe Zeus::ParallelTests::Worker do
  describe ".run" do
    let(:cli_argv) { ["rspec", "spec/models/model_spec.rb"] }
    let(:cli_env)  { {"TEST_ENV_NUMBER" => "3"} }
    let(:worker)   { double("worker", spawn: 0) }
    before  { Zeus::ParallelTests::Worker.stub(new: worker) }
    subject { Zeus::ParallelTests::Worker.run(cli_argv, cli_env)  }

    it "creates instance of worker" do
      Zeus::ParallelTests::Worker.should_receive(:new)
        .with("rspec", cli_env, ["spec/models/model_spec.rb"])
        .and_return(worker)
      subject
    end

    it "does not modify original env and argv" do
      subject
      expect(cli_argv).to eq(["rspec", "spec/models/model_spec.rb"])
      expect(cli_env).to eq({"TEST_ENV_NUMBER" => "3"})
    end

    it "returns exit code" do
      expect(subject).to eq(0)
    end
  end

  describe "#spawn" do
    subject { worker.spawn }
    let(:worker) { Zeus::ParallelTests::Worker.new("rspec", cli_env, ["spec/file_spec.rb"]) }
    let(:cli_env) { {"TEST_ENV_NUMBER" => 2, "PARALLEL_TEST_GROUPS" => 4} }
    let(:argv_file) { double("argv_file", path: "argv_file_path", unlink: true, puts: nil, close: nil) }
    before do
      Tempfile.stub(new: argv_file)
      worker.stub(system: true)
    end

    it "writes args to file" do
      argv_file.should_receive(:puts).with("spec/file_spec.rb")
      subject
    end

    it "spawns worker and passes TEST_ENV_NUMBER, PARALLEL_TEST_GROUPS and argv file path" do
      worker.should_receive(:system).with("zeus parallel_rspec_worker 2 4 argv_file_path")
      subject
    end

    it "removes argv_file after run" do
      argv_file.should_receive(:unlink)
      subject
    end

    it "returns exit code" do
      worker.should_receive(:system) { $?.stub(to_i: 1) }
      expect(subject).to eq(1)
    end
  end
end
