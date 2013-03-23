require 'zeus/parallel_tests'

class CustomPlan < Zeus::ParallelTests::Rails
  # Your custom methods go here
end

Zeus.plan = CustomPlan.new
