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
      Twirb.client.search(:to => Twirb.login, :rpp => 1000).reverse.each do |status|
        begin
          block.call(Status.create(:twitter_id => status.id, :created_at => status.created_at, :from_user => status.from_user, :to_user => status.to_user, :text => status.text, :source => status.source))
        rescue ActiveRecord::StatementInvalid => e
          # ingore it if the status exists already.
        end
      end
  end

end
