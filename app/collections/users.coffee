#UserSchema = new SimpleSchema
#  username:
#    label: 'Username'
#    type: String,
#    index: true,
#    unique: true
#  name:
#    label: 'Name'
#    type: String,
#  bio:
#    label: 'Biography'
#    type: String
#    optional: true
#
#@Users = new Meteor.Collection 'users', schema: UserSchema
@Users = Meteor.users

Meteor.startup ->
  Tags.TagsMixin(Users);
  # TODO(orlade): Allow tags from core team members (just be logged in for now).
  Users.allowTags (userId) -> userId == Meteor.userId()
