#!/usr/bin/env ruby
require_relative '../worker'
exit Zeus::ParallelTests::Worker.new(File.basename(__FILE__, ".*"), ENV, ARGV).call
