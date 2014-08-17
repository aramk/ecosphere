TemplateClass = Template.header

TemplateClass.helpers
  userDisplayName: -> Meteor.user().username || Meteor.user().emails[0].address.split('@')[0]

TemplateClass.rendered = ->
  $('.ui.dropdown').dropdown()
