module Twirb
  def self.client=(x)
    @@client = x
  end
  def self.client
    @@client
  end
  def self.login=(x)
    @@login=x
  end
  def self.login
    @@login
  end
  def self.app_path=(x)
    @@app_path = x
  end
  def self.app_path
    @@app_path
  end
  def self.version
    "Twirb 2010.04.12"
  end

  def self.config 
    # Set up the twitter connection...
    require 'twitter'
    Twitter::Client.configure do |conf|
      conf.application_name = 'Twirb'
      conf.application_version = '2010.04.10'
      conf.application_url = 'http://tryruby.org/'
      conf.user_agent = "#{conf.application_name} (#{conf.application_version}) #{conf.application_url}"
      #conf.source = ''
    end
    Twirb.client = Twitter::Client.from_config(Twirb.app_path + '/twitter.yml')
    Twirb.login = YAML::load_file(Twirb.app_path+'/twitter.yml').values.first['login']

    # Make sure active record is ready to help us out...
    require 'active_record'
    ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => Twirb.app_path + '/twirb.sqlite', :encoding => 'utf8'
    if !ActiveRecord::Base.connection.table_exists? 'statuses'
      ActiveRecord::Base.connection.create_table :statuses do |t|
        t.string :source
        t.string :from_user
        t.string :to_user
        t.integer :twitter_id
        t.string :text
        t.timestamps
      end
      ActiveRecord::Base.connection.add_index :statuses, :twitter_id, :unique => true
    end
    if !ActiveRecord::Base.connection.table_exists? 'codes'
    end
    instance_eval <<-RUBY
      class ::Status < ActiveRecord::Base
        named_scope :from, lambda { |name| { :conditions => { :from_user => name } } }
        named_scope :to_me, :conditions => { :to_user => Twirb.login }
        def code
          (text.split("@#{Twirb.login}") * "").strip
        end
      end
    RUBY
  end
end
