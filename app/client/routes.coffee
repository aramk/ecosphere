####################################################################################################
# CONFIG
####################################################################################################

AuthController = RouteController.extend({})

crudRoute = (collectionName, controller) ->
  controller ?= AuthController
  collectionId = Strings.firstToLowerCase(collectionName)
  singularName = Strings.singular(collectionId)
  itemRoute = singularName + 'Item'
  editRoute = singularName + 'Edit'
  formName = singularName + 'Form'
  Router.map ->
    this.route collectionId, {path: '/' + collectionId, controller: controller, template: collectionId}
    this.route itemRoute,
      path: '/' + collectionId + '/create', controller: controller, template: formName
      data: -> {}
    this.route editRoute,
      # Reuse the itemRoute for editing.
      path: '/' + collectionId + '/:_id/edit', controller: controller, template: formName
      data: -> {doc: window[collectionName].findOne(this.params._id)}

Router.onBeforeAction (pause) ->
#  TODO(aramk) Add back when we have auth.
#  # This redirects users to a sign in form.
#  AccountsEntry.signInRequired(this.router)
#  TODO(aramk) Add back when we have auth.
#  # Empty path is needed for page not found.
#  whiteList = ['', '/sign-in', '/sign-out', '/sign-up', '/forgot-password']
#  isWhiteListed = Arrays.trueMap(whiteList)[this.path];
#  if !isWhiteListed && !Meteor.user()
#    this.render('accessDenied')
#    pause()
#  else
  if this.path == '/' || this.path == ''
    Router.go('projects')
  Router.initLastPath()

####################################################################################################
# ROUTES
####################################################################################################

ProjectController = RouteController.extend
  template: 'project'
  waitOn: ->
    Meteor.subscribe('projects')
# TODO(aramk) Waiting on more than one doesn't work.
#    _.map(['projects', 'entities', 'typologies'], (name) -> Meteor.subscribe(name))
  onBeforeAction: ->
    id = @.params._id
    Projects.setCurrentId(id)

ProjectsController = RouteController.extend
  template: 'projects'
  waitOn: -> Meteor.subscribe('projects')

crudRoute('Projects')

Router.map ->
  this.route 'project', {
    path: '/projects/:_id'
    controller: ProjectController
    waitOn: -> Meteor.subscribe('projects')
    data: ->
      project: Projects.findOne(@params._id)
  }

  @route 'users',
    path: '/users'
    waitOn: -> Meteor.subscribe 'users'
    data: ->
      users: Users.find().fetch()

  @route 'user',
    path: '/users/:username'
    waitOn: -> Meteor.subscribe 'users'
    data: -> Users.findOne {username: @params.username}

####################################################################################################
# AUXILIARY
####################################################################################################

# Allow storing the last route visited and switching back.
origGoFunc = Router.go
_lastPath = null
Router.setLastPath = (name, params) ->
  _lastPath = {name: name, params: params}
Router.getLastPath = -> _lastPath
Router.goToLastPath = ->
  name = _lastPath.name
  current = Router.current()
  if _lastPath? and current.route.name != name
    origGoFunc.call(Router, name, _lastPath.params)
    true
  else
    false

Router.setLastPathAsCurrent = ->
  current = Router.current()
  if current
    Router.setLastPath(current.route.name, current.params)

# When switching, remember the last route.
Router.go = ->
  Router.setLastPathAsCurrent()
  origGoFunc.apply(@, arguments)

Router.initLastPath = ->
  unless _lastPath?
    Router.setLastPathAsCurrent()
