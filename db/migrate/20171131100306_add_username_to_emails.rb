class AddUsernameToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :username, :string
  end
end
