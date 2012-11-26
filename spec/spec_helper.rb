require 'rubygems'
require 'bundler'

Bundler.require :default, :test

$:.unshift "lib"
require 'gdash/ganglia'

def app
  GDash::App
end

RSpec.configure do |config|
  config.after do
    GDash::Widget.instance_variable_set :@widgets, nil
  end
end
