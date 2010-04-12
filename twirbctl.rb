#!ruby

require 'rubygems'
require 'bundler'
Bundler.setup
require 'daemons'

Daemons.run 'twirb.rb'
