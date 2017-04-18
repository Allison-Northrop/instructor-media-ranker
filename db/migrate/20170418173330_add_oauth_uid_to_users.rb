class AddOauthUidToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :oauth_uid, :string
  end
end
