class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
      t.string :username
      t.string :title
      t.string :message

      t.timestamps null: false
    end
  end
end
