== Email-like 

A project intented to simulate sending and receiving text messages as an email client. 

UI based on Jakub Antalik's concept https://dribbble.com/shots/2359374-Mail-client-app



Login with test credentials: 
- username: testuser
- password: testpassword



The main functionality is:
- sending and receiving emails
- forwarding and responding to received emails
- assigning labels to emails
- saving emails in creation as drafts
- adding contacts to browse past message exchange
- other CRUD operations on email/label/draft/user/contact models



Things used in creation:
* authentication with has_secure_password
* ajax responses
* tests with Rspec/Capybara/FactoryBot
* JS and JQuery to provide interaction
* mark.js for searching for a phrase in a message
* fontawesome for icons