TemplateClass = Template.users;

goToUser = (user) ->
  Router.go 'users', {username: user.username}

TemplateClass.users = -> Users.find().fetch()

TemplateClass.rendered = ->
  # TODO(aramk) This is here since the router doesn't call hooks when revisting...
  Session.set('stateName', 'Users')
  # Add a launch button to the table toolbar.
  $table = $(@find('.collection-table'))
  $buttons = $('.on-selection-show', $table)
  $btnLaunch = $('<a class="launch item"><i class="rocket icon"></i></a>')
  $btnLaunch.on 'click', () ->
    id = $('.selected[data-id]', $table).data('id')
    goToUser(id)
  $buttons.append($btnLaunch)

TemplateClass.helpers
  tableSettings: -> {
  fields: [
    key: 'username'
    label: 'Username'
  ]
  onEdit: (args) ->
    console.debug 'onEdit', arguments
    if args.event?.type == 'dblclick'
      goToUser(args.id)
    else
      args.defaultHandler()
  onDelete: (args) ->
    id = args.id
    Meteor.call('users/remove', id);
  }
