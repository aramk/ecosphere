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
      $map = $(template.find('.map'))
      map = $map.data('gmap')
      df.resolve(map)
  )
  df.promise

markers = {}

closeAllInfoWindows = ->
  getMap().then (map) ->
    _.each markers, (marker) ->
      marker.infoWindow?.close()

addMarker = (args) ->
  id = args.id
  unless id
    throw new Error('No ID provided for marker')
  location = args.location
  content = args.content
  getMap().then (map) ->
    pos = new google.maps.LatLng location.lat, location.lng
    marker = new google.maps.Marker
      position: pos,
      map: map,
      title: args.title
    if content?
      infoWindow = new google.maps.InfoWindow
        content: content
      marker.infoWindow = infoWindow
      google.maps.event.addListener marker, 'click', ->
        closeAllInfoWindows().then -> infoWindow.open map, marker
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
    title = project.name
    desc = project.desc
    locationName = if location.name then location.name + ' - ' else ''
    lat = location.lat
    lng = location.lng
    coords = if lat? && lng? then lat.toFixed(6) + ', ' + lng.toFixed(6)
    content = '<div class="title">' + title + '</div><div class="desc">' + desc + '</div>' +
      '<div class="location"><i class="globe icon"></i> ' + locationName + coords + '</div>'
    addMarker id: id, title: title, location: location, content: content

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

  # Hide info windows on map click.
  getMap().then (map) ->
    google.maps.event.addListener map, 'click', -> closeAllInfoWindows()

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
