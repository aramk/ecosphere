####################################################################################################
# CONFIG
####################################################################################################

crudRoute = (collectionName, controller) ->
  controller ?= AuthController
  collectionId = Strings.firstToLowerCase(collectionName)
  singularName = Strings.singular(collectionId)

  listRoute = collectionId
  itemRoute = singularName
  createRoute = singularName + 'Create'
  editRoute = singularName + 'Edit'
  formName = singularName + 'Form'

  Router.map ->
    # Displays a list of items in the collection.
    @route listRoute,
      path: '/' + collectionId,
      controller: controller,
      template: collectionId

    # Displays a form to create a new item in the collection.
    # Note: Must be before itemRoute to match the path first.
    @route createRoute,
      path: '/' + collectionId + '/create', controller: controller, template: formName
      waitOn: -> Meteor.subscribe(collectionId)
      data: -> {}
      onBeforeAction: -> AccountsEntry.signInRequired @
      action: -> if @ready() then @render()

    # Displays a form to edit the contents of an item in the collection.
    @route editRoute,
      # Reuse the itemRoute for editing.
      path: '/' + collectionId + '/:_id/edit', controller: controller, template: formName
      waitOn: -> Meteor.subscribe(collectionId)
      data: ->
        doc = window[collectionName].findOne(@params._id)
        console.debug('doc', doc, collectionName, @)
        {doc: doc}
      onBeforeAction: -> AccountsEntry.signInRequired @
      action: -> if @ready() then @render()

    # Displays the details of an item in the collection.
    @route itemRoute,
      path: '/' + collectionId + '/:_id',
      controller: controller,
      waitOn: -> Meteor.subscribe(collectionId)
      data: -> project: Projects.findOne(@params._id)
      action: -> if @ready() then @render()

Router.onBeforeAction (pause) ->
##  TODO(aramk) Add back when we have auth.
#  # This redirects users to a sign in form.
#  AccountsEntry.signInRequired(this.router)
#
#  #  TODO(aramk) Add back when we have auth.
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

# Create CRUD routes for Project items.
crudRoute('Projects')

# Set up the rest of the routes.
Router.map ->
  # Display an overview of the system.
  @route 'home',
    path: '/'

  # Display a list of users.
  @route 'users',
    path: '/users'
    waitOn: -> Meteor.subscribe 'users'
    data: -> users: Users.find().fetch()

  # Displays details about a user.
  @route 'user',
    path: '/users/:username'
    waitOn: -> Meteor.subscribe 'users'
    data: -> Users.findOne {username: @params.username}

  # Display the search template to search application data.
  @route 'search',
    path: '/search'
    data: -> query: @params.query

####################################################################################################
# CONTROLLERS
####################################################################################################

AuthController = RouteController.extend({})

ProjectController = RouteController.extend
  template: 'project'
  waitOn: -> Meteor.subscribe('projects')
# TODO(aramk) Waiting on more than one doesn't work.
#    _.map(['projects', 'entities', 'typologies'], (name) -> Meteor.subscribe(name))
  onBeforeAction: -> Projects.setCurrentId(@.params._id)

ProjectsController = RouteController.extend
  template: 'projects'

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
