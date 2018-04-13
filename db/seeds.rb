# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# seed users
testuser = User.create(username: "testuser", password: "testpassword", password_confirmation: "testpassword")

User.create(username: "John", password: "qwertyui", password_confirmation: "qwertyui")
User.create(username: "Michael", password: "qwertyui", password_confirmation: "qwertyui") 
User.create(username: "Jack Jaques", password: "qwertyui", password_confirmation: "qwertyui") 
User.create(username: "Jean", password: "qwertyui", password_confirmation: "qwertyui") 
User.create(username: "Mark", password: "qwertyui", password_confirmation: "qwertyui") 


# seed labels
Label.create(name: "Personal", user_id: testuser.id) 
Label.create(name: "Work", user_id: testuser.id) 
Label.create(name: "Travel", user_id: testuser.id) 


# seed emails
15.times { |i| Email.create(
  username: User.all[-(rand(5) + 1)].username,
  title: "message-#{i}",
  message: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Error vero qui labore vitae nesciunt! Esse maiores at sunt cupiditate reiciendis est laudantium ea. Repellat ipsum doloremque impedit atque corporis. Tempora. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Error vero qui labore vitae nesciunt! Esse maiores at sunt cupiditate reiciendis est laudantium ea. Repellat ipsum doloremque impedit atque corporis. Tempora.Lorem ipsum dolor sit amet, consectetur adipisicing elit. Error vero qui labore vitae nesciunt! Esse maiores at sunt cupiditate reiciendis est laudantium ea. Repellat ipsum doloremque impedit atque corporis. Tempora.",
  user_id: testuser.id,
  label_id: rand(3) + 1,
  interlocutor_id: User.all[-(rand(5) + 1)],
  message_type: 'received'
)}


15.times { |i| Email.create(
  username: User.all[-(rand(5) + 1)].username,
  title: "message-#{i}",
  message: "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Error vero qui labore vitae nesciunt! Esse maiores at sunt cupiditate reiciendis est laudantium ea. Repellat ipsum doloremque impedit atque corporis. Tempora. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Error vero qui labore vitae nesciunt! Esse maiores at sunt cupiditate reiciendis est laudantium ea. Repellat ipsum doloremque impedit atque corporis. Tempora.Lorem ipsum dolor sit amet, consectetur adipisicing elit. Error vero qui labore vitae nesciunt! Esse maiores at sunt cupiditate reiciendis est laudantium ea. Repellat ipsum doloremque impedit atque corporis. Tempora.",
  user_id: testuser.id,
  label_id: rand(3) + 1,
  interlocutor_id: User.all[-(rand(5) + 1)],
  message_type: 'sent'
)}


# assign some emails to trash 
6.times { Email.all[rand(Email.count)].update_attribute(:trash, true) }


# seed drafts
5.times { |i| Draft.create(
  username: User.all[-(rand(5) + 1)].username,
  title: "Draft-#{i}",
  message: "Lore-#{i}",
  user_id: testuser.id
)}


# add contacts
User.all[-1..-5].each { |c| Contact.create(user_id: testuser.id, name: c.username) }