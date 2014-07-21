Meteor.publish 'projects', -> Projects.find()

Meteor.publish 'users', -> Meteor.users.find {}, {fields: {
  _id: 1,
  username: 1,
  emails: 1,
  profile: 1,
  tags: 1
}}

Meteor.publish 'tags', -> Meteor.tags.find()
