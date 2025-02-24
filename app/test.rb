require 'bundler/setup'

@ARGV = ['main', '-d', '-f', 'spec/fixtures/InputFile']
require './main'
