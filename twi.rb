require 'rubygems'
require 'bundler'
require 'thread'
require 'cgi'
Bundler.setup

require File.dirname(__FILE__) + '/lib/twirb/config.rb'
require File.dirname(__FILE__) + '/lib/twirb/loop.rb'
require File.dirname(__FILE__) + '/lib/tryruby/tryruby.rb'
require File.dirname(__FILE__) + '/lib/twirb/session.rb'

Twirb.app_path = File.dirname(__FILE__)
Twirb.config

#require 'irb'
#IRB.start
#exit

Twirb.loop do |status|
  # status is an ActiveRecord model containing
  # a new mention on twitter. Simple, eh?

  puts "recieved #{status.code.inspect} from #{status.from_user.inspect}"
  session = Twirb::Session.for(status.from_user)
  result = session.run_line(status.code)
  puts result.format
  maxlength = 120 - status.from_user.size - 3
  begin
    result.format.scan(Regexp.new(".{0,#{maxlength}}")).each do |text|
      Twirb.client.status(:post, "@#{status.from_user} #{text}")
    end
  rescue Exception => e
    begin
      Twirb.client.status(:post, "@#{status.from_user} Error: Unable to post results to twitter.")
    rescue Exception => ee
    ensure
      puts e.inspect
    end
  end
  
end

