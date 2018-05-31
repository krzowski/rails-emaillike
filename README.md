# Email-like - an email client imitation

## about the project
Email-like is a Rails application inspired by a [design concept by Jakub Antalik from dribbble](https://dribbble.com/shots/2359374-Mail-client-app). It is intended to simulate sending and receiving email-like text messages.

Email-like functionality includes:

* assigning labels to messages
* saving messages in creation as drafts
* putting deleted emails in trash before a final delete
* adding contacts to easily browse past message exchanges
* forwarding and responding options for text messages
* other CRUD operations on email/label/draft/user/contact models


Email-like was developed with use of:

* authentication with bcrypt and has_secure_password
* jquery + ajax (by remote: true)
* **tests with Rspec/Capybara/FactoryBot**
* mark.js for searching for a phrase in a message and highlighting it
* fontawesome for icons


## try it out
visit [project's website](http://emaillike.herokuapp.com/)(may take up to 10s to wake up from sleep) and log in with test credentials:

* username: testuser, password: testpassword

or create your own account!


## local setup
download the code:

    git clone https://github.com/krzowski/rails-emaillike.git

navigate to root folder and install dependencies with:

    cd rails-emaillike/ && bundle update

run database migrations:

    rake db:migrate

start server with:

    rails s
