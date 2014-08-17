TemplateClass = Template.header

TemplateClass.helpers
  userDisplayName: ->

TemplateClass.rendered = ->
  $('.ui.dropdown').dropdown()
