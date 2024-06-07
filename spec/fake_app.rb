ENV["RAILS_ENV"] = "test"

require 'rails'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3', 
  database: ':memory:'
)

module FakeApp
  class Application < Rails::Application
    config.eager_load = false
    # config.root = File.dirname(__FILE__)
    config.root = File.dirname(__FILE__) + '/fake_app'

    if Rails.gem_version >= Gem::Version.new("7.1")
      config.active_support.cache_format_version = 7
    end
  end
end

# Rails.logger = Logger.new("/dev/null")
FakeApp::Application.initialize!


# Migration
class CreateAllTables < ActiveRecord::Migration[5.0]
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :login_id
      t.string :password_digest
      t.timestamps
    end

    create_table :articles do |t|
      t.string :title
      t.text :content
      t.references :user
      t.timestamps
    end
  end
end

CreateAllTables.up unless ActiveRecord::Base.connection.table_exists? 'articles'
