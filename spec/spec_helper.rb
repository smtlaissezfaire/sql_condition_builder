require "rubygems"
require "active_record"
require 'sqlite3'

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database  => ':memory:'

require File.expand_path(File.dirname(__FILE__) + "/../lib/sql_condition_builder")
