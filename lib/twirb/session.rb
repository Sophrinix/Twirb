module Twirb

  class Session < TryRuby::Session

    attr_accessor :current_statement
    attr_accessor :past_commands
    attr_accessor :start_time

    @@users = {}

    def self.for(user)
      @@users[user] ||= Session.new(user)
    end

    def initialize(user)
      @user = user
      @current_statement = ''
      @past_commands = ''
      @start_time ||= Time.now
    end

  end
end

