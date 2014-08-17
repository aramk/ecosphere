TemplateClass = Template.help

categories = ['index']

#TemplateClass.created = ->
#  unless index
#    Meteor.call 'loadHelp', category, (err, text) ->
#      Session.set "help/#{category}", text
#
#  for category in ['phases', 'resources']
#    unless Session.get "help/#{category}"
#      Meteor.call 'loadHelp', category, (err, text) ->
#        Session.set "help/#{category}", text

TemplateClass.helpers
  category: Session.get 'help/category'
  content: ->
    unless Session.get "help/#{@category}"
      Meteor.call 'loadHelp', @category, (err, text) ->
        Session.set "help/#{@category}", text
        console.debug Session.get "help/#{@category}"
    console.debug 'returning help', Session.get "help/#{@category}"
    # TODO(orlade): Make this more reactive so that it's displayed once it's loaded.
    Session.get "help/#{@category}"

  phasesHelp: -> Session.get 'help/phases'
  resourcesHelp: -> Session.get 'help/resources'
