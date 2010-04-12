module Twirb

  def self.loop(&block)
    while(true) do
      puts "Calling..."
      self.once(&block)
      puts "Sleeping..."
      sleep(30)
    end
  end

  def self.once(&block)
    begin
      Twirb.client.search(:to => Twirb.login, :rpp => 1000).each do |status|
        block.call(Status.create(:twitter_id => status.id, :created_at => status.created_at, :from_user => status.from_user, :to_user => status.to_user, :text => status.text, :source => status.source))
      end
    rescue ActiveRecord::StatementInvalid => e
      # ingore it if the status exists already.
    end
  end

end
