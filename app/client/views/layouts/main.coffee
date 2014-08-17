TemplateClass = Template.mainLayout

TemplateClass.rendered = ->
  document.title = App.name
  $('head').append('<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />');


TemplateClass.helpers
  stateName: -> Session.get('stateName')
  project: -> Projects.getCurrent()


TemplateClass.events
  'click .logo': ->
    Router.go('projects')
    Projects.setCurrentId(null)
  'click .edit.button': ->
    Template.design.setUpFormPanel null, Template.projectForm, Projects.getCurrent()
#    Router.go 'projectEdit', {_id: Projects.getCurrentId()}
  'click .import.button': ->
    Template.design.setUpFormPanel null, Template.importForm

  'click .logout': ->
    Meteor.logout (err) ->
      if err then console.error(err) else console.debug("Logged out")
