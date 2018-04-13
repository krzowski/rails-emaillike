class RemoveFriendIdAndAddNameToContacts < ActiveRecord::Migration
  def change
    remove_column :contacts, :friend_id
    add_column :contacts, :name, :string
  end
end
