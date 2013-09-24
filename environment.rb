Encoding.default_internal = 'UTF-8'
require 'rubygems'
require 'bundler/setup'
Bundler.require

require File.join(File.expand_path(File.dirname(__FILE__)), 'secrets.rb')

Dir.glob(['lib', 'models'].map! {|d| File.join File.expand_path(File.dirname(__FILE__)), d, '*.rb'}).each {|f| require f}

DataMapper.finalize # hack due to some bug in this version
 
DataMapper.setup(:default, "postgres://:@localhost/#{APP_NAME}") # runs locally