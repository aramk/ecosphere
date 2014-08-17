TemplateClass = Template.projects

goToProject = (id) ->
  Router.go 'project', {_id: id}

getProjects = -> Projects.find()

addMarker = (template, args) ->
  location = args.location
  GoogleMaps.init(
    {}
    ->
      console.debug google.maps
      pos = new google.maps.LatLng location.lat, location.lng
      $map = $(template.find('.map'))
      map = $map.data('gmap')
      console.log('$map', $map)
      console.log('map', map)
      marker = new google.maps.Marker
        position: pos,
        map: map,
        title: args.title

      console.log('marker', marker)
  )

TemplateClass.rendered = ->
  console.log('projects rendered', @);
  # TODO(aramk) This is here since the router doesn't call hooks when revisting...
  Session.set('stateName', 'Projects')
  # Add a launch button to the table toolbar.
  $table = $(@find('.collection-table'))
  $buttons = $('.on-selection-show', $table)
  $btnLaunch = $('<a class="launch item"><i class="rocket icon"></i></a>')
  $btnLaunch.on 'click', () ->
    id = $('.selected[data-id]', $table).data('id')
    goToProject(id)
  $buttons.append($btnLaunch)

  template = @
  Deps.autorun ->
    _.each Projects.find().fetch(), (project) ->
      location = project.location
      if location?
        args =
          title: project.name, location: location
        addMarker template, args


TemplateClass.helpers
  projects: getProjects

  tableSettings: ->
    fields: [
      key: 'name'
      label: 'Name'
    ]

    onEdit: (args) ->
      console.debug 'onEdit', arguments
      if args.event?.type == 'dblclick'
        goToProject(args.id)
      else
        args.defaultHandler()

    onDelete: (args) ->
      Meteor.call 'projects/remove', args.id

  mapSettings: -> {

  }
