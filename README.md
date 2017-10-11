# CateChat

# Author
Chayce Heiberg
Chayce.heiberg@wsu.edu

# About
This is an iOS instant-messaging app that uses Firebase to store data and handle user authentication. User can create an account with an email, username, and password, along with a profile image. Users have access to a public directory of every user that has signed up, and message them. The backend consists of three json trees (users, messages, user-messages).

Each message node has a messageID, userID, text, time stamp in order to group messages easily between two users. Whenver a message is sent, a user-message node is also created that holds the fromUserID, toUserID, and messageID.

![message](https://user-images.githubusercontent.com/11234867/31314323-108f39d4-abb3-11e7-990d-947d7125d479.png)

# Features to Implement
- Change the input accessory view to look similar to imessage's input view
- Fix flickering effect when users load in contact list
- Add image messaging feature

# Future ideas
- Build a neural network that allows users to draw words that recognize the text and send them as a message.

