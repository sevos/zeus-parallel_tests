# Zeus::ParallelTests

[![No Maintenance Intended](http://unmaintained.tech/badge.svg)](http://unmaintained.tech/)
[![Circle CI](https://circleci.com/gh/sevos/zeus-parallel_tests.svg?style=svg)](https://circleci.com/gh/sevos/zeus-parallel_tests)
[![Dependency Status](https://gemnasium.com/sevos/zeus-parallel_tests.png)](https://gemnasium.com/sevos/zeus-parallel_tests)
[![Gem Version](https://badge.fury.io/rb/zeus-parallel_tests.svg)](http://badge.fury.io/rb/zeus-parallel_tests)

[Zeus](https://github.com/burke/zeus) is a tool for speeding up your tests by preloading a Rails app.
[parallel_tests](https://github.com/grosser/parallel_tests) also speeds up your tests by running them, well,
in parallel. Two good gems, so why not to use them together? Let's make our CPUs sweat!

## Show me the numbers!

### RSpec

```
$ time rspec spec

...

Finished in 1 minute 8.34 seconds
916 examples, 0 failures

real    1m21.480s
user    1m4.805s
sys     0m4.516s
```

### parallel_tests

```
$ time rake parallel:spec[8]
Using recorded test runtime
8 processes for 141 specs, ~ 17 specs per process

...

916 examples, 0 failures

Took 46.626499 seconds

real    0m55.790s
user    4m3.065s
sys     0m32.160s
```

### Zeus+parallel_tests

```
$ time zeus rake parallel:spec[8]
Developer helpers loaded
Using recorded test runtime
8 processes for 141 specs, ~ 17 specs per process

...

916 examples, 0 failures

Took 26.610327 seconds

real    0m28.514s
user    0m0.732s
sys     0m0.061s
```

Ready to go?

## Installation
  
[RailsCast episode #413 Fast Tests](http://railscasts.com/episodes/413-fast-tests)  

Add this line to your application's Gemfile:

    gem 'zeus-parallel_tests'

And then execute:

    $ bundle

You need also to initialize your project with custom Zeus plan:

    $ zeus-parallel_tests init

This will create two files in your project:

* custom_plan.rb
* zeus.json

### RVM

For RVM users it is recommended to install rubygems-bundler gem.

## Usage

First [follow instructions](https://github.com/grosser/parallel_tests) and prepare
your application to use parallel_tests.

Launch another terminal and run zeus' master process:

    $ bundle exec zeus start

Then you can run your parallel specs:

    $ zeus parallel_rspec spec

or your cucumbers:

    $ zeus parallel_cucumber features

## What is supported?

* rspec
* cucumber
* guard-rspec since v2.5.2 (just pass `zeus: true` and `parallel: true` into configuration hash, you can play with `bundler: false` option to speed things up)
* caching: you must set `config.cache_store = :memory_store` as Zeus will not reload the various cache files used by parallel_tests instances

## TODO

* minitest support


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
