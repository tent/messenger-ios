messenger-ios
=============

This is the work in progress Tent-powered messenger app from Cupcake.

We aren't sure what approach we'll take to licensing yet, so this code is currently all copyrighted with rights reserved, we're making it available for informational purposes only at present.

One of the great things about Tent is that apps that do the same thing can be compatible and even swappable. The messenger space is an opportunity for the Tent ecosystem to demonstrate what's possible. The messenger market as a whole is extremely fragmented, Tent could be what unifies it. To that end, we **strongly** encourage everyone developing Tent powered messenger apps to standardize on a single post scheme.

## Roadmap

Because this will be the first set of applications to focus on group collaboration, we really want to get this right. The Tent protocol is still being actively developed, which will impact the roadmap for messenger development (see below).

1. Text-only messaging
2. Media support 
3. 0.4 support (0.4 groups allow users to set another entity's group as the permissions to a post. This is extremely useful for collaborative apps as the entity which initiates a multi-user chat can add and remove users to the conversation. This feature may also be leveraged in the cryptographic strategy for messaging. Additionally the web of trust planned for 0.4 will have implications for contact verification.)
4. Cryptographic support (It is vital that any applications attempting interoperability share the same cryptographic strategy.) 


We really want to all the apps in this space to play well with each other. We'll publish a post scheme soon and posssibly a test suite to further that goal

## Post Scheme

Every conversation is composed of one `conversation` post and many `message` posts. Each `message` post _mentions_ and _refs_ the `conversation` post and all the conversation participants.

Apps may (but are not required to) limit permissions on both `conversation` and `message` posts to conversation participants.

Media will be addressed in the future.

### Conversation Post

To create a converation, an entity creates a `conversation` post which _mentions_ all intended participants.

The participants of a conversation are the entity who created the `conversation` post plus all those _mentioned_ in the `conversation` post.

| Field | Required | Type | Description |
| ----- | -------- | ---- | ----------- |
| | | |

(post contains no fields)

### Message Post

Each message post must _mention_ and _ref_ both the `conversation` post and _mention_ each participant in the conversation.

| Field | Required | Type | Description |
| ----- | -------- | ---- | ----------- |
| `text` | Optional | 	String | The message in UTF-8 encoding, max 2,000 unicode code points. |
