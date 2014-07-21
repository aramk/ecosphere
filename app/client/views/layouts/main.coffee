Template.mainLayout.helpers
  stateName: -> Session.get('stateName')
  project: -> Projects.getCurrent()
  currentUser: -> Meteor.user()

Template.mainLayout.events
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
