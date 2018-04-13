class CreateEmails < ActiveRecord::Migration
  # rails generate model Email title:text message:text user:references interlocutor:references message_type:string label:references

  def change
    create_table :emails do |t|
      t.text :title
      t.text :message
      t.references :user, index: true, foreign_key: true
      t.references :interlocutor, index: true, foreign_key: true
      t.string :message_type, index: true
      t.references :label, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
