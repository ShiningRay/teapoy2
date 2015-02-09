# coding: utf-8
require 'rubygems'
Encoding.default_external = Encoding.default_internal = Encoding::UTF_8 if RUBY_VERSION >= '1.9'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
