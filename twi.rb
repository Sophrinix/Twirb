require 'rubygems'
require 'bundler'
require 'thread'
Bundler.setup

require File.dirname(__FILE__) + '/lib/twirb/config.rb'
require File.dirname(__FILE__) + '/lib/twirb/loop.rb'
require File.dirname(__FILE__) + '/lib/tryruby/tryruby.rb'
require File.dirname(__FILE__) + '/lib/twirb/session.rb'

Twirb.app_path = File.dirname(__FILE__)
Twirb.config

Twirb.loop do |status|
  # status is an ActiveRecord model containing
  # a new mention on twitter. Simple, eh?

  puts "recieved #{status.code.inspect} from #{status.from_user.inspect}"
  session = Twirb::Session.for(status.from_user)
  result = session.run_line(status.code)
  puts results.format
  result.format.scan(/.{0,120}/).each do |text|
    Twirb.client.status(:post, result)
  end
  
end

