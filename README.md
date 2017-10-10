# About
This is an ios instant-messaging app that uses Firebase to store data and handle user authentication. User can create an account with an email, username, and password, along with a profile image. Users have access to a public directory of every user that has signed up, and message them. The backend consists of three json trees (users, messages, user-messages).

Each message node has a messageID, userID, text, time stamp in order to group messages easily between two users. Whenver a message is sent, a user-message node is also created that holds the fromUserID, toUserID, and messageID.
