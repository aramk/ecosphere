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
