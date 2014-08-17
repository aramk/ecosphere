TemplateClass = Template.projects

goToProject = (id) ->
  Router.go 'project', {_id: id}

getProjects = -> Projects.find()

# This assumes we only ever have one instance of this template.
template = null

getMap = ->
  df = Q.defer()
  GoogleMaps.init(
    {}
    ->
      console.debug google.maps
      $map = $(template.find('.map'))
      map = $map.data('gmap')
      console.log('map', map)
      df.resolve(map)
  )
  df.promise

markers = {}

addMarker = (args) ->
  id = args.id
  unless id
    throw new Error('No ID provided for marker')
  location = args.location
  getMap().then (map) ->
    console.debug google.maps
    pos = new google.maps.LatLng location.lat, location.lng
    $map = $(template.find('.map'))
    marker = new google.maps.Marker
      position: pos,
      map: map,
      title: args.title
    console.log('marker', marker)
    markers[id] = marker
    marker

getMarker = (id) ->
  markers[id]

removeMarker = (id) ->
  marker = getMarker(id)
  if marker
    marker.setMap(null);

addProjectMarker = (id) ->
  project = Projects.findOne(id)
  location = project.location
  if location?
    addMarker id: id, title: project.name, location: location

TemplateClass.rendered = ->
  template = @
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

  # Create markers for projects.
  projects = Projects.find()
  projects.observe
    added: (project) ->
      console.log('added', arguments)
      addProjectMarker(project._id)
    changed: (newProject, oldProject) ->
      console.log('changed', arguments)
      id = newProject._id
      removeMarker(id)
      addProjectMarker(id)
    removed: (oldProject) ->
      console.log('removed', arguments)
      removeMarker(oldProject._id)

#  Deps.autorun ->
#    _.each Projects.find().fetch(), (project) ->
#      location = project.location
#      addMarker template, {title: project.name, location: location}

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
