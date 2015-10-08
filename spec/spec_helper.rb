ENV["RAILS_ENV"] = 'test'
require 'bundler'
require 'bundler/setup'
require 'cloudxls'

RSpec.configure do |config|
  #config.color_enabled = true
  config.order = "random"
end
