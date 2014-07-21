getMap = (template) ->
  $map = $(template.find('.map'))
  map = $map.data('gmap')

marker = null
getMarker = (template) -> marker #template.marker
setMarker = (template, _marker) ->
  marker = _marker
  #template.marker = marker
  console.error('get template marker', template, marker)

getMarkerLatLng = (template) ->
  marker = getMarker(template)
  if marker
    pos = marker.getPosition()
    location = {lat: pos.lat(), lng: pos.lng()}
    location
  else
    null

# TODO(aramk) Refactor with projects
addMarker = (template, args) ->
  location = args.location
  GoogleMaps.init(
    {}
    ->
      pos = new google.maps.LatLng(location.lat, location.lng)
      map = getMap(template)
      console.log('map', map)
      marker = getMarker()
      console.error('template marker', marker)
      if marker
        marker.setPosition(pos)
        return
      marker = new google.maps.Marker({
        position: pos
        map: map
        title: args.title
        draggable: true
        animation: google.maps.Animation.DROP
      })
      toggleBounce = ->
        if marker.getAnimation()
          marker.setAnimation(null)
        else
          marker.setAnimation(google.maps.Animation.BOUNCE)
      google.maps.event.addListener(marker, 'click', toggleBounce);
      console.log('marker', marker)
      setMarker(template, marker)
  )

Meteor.startup ->

  close = ->
    unless Router.current().route.name == 'project'
      Router.goToLastPath() or Router.go('projects')

  Form = Forms.defineModelForm
    name: 'projectForm'
    collection: 'Projects'
    onSuccess: close
    onCancel: close
    onRender: ->
      template = @
      console.log('template', template)
      project = @data.doc
      console.log('doc', project)
      location = project?.location

      setMarker(template, null)
      addProjectMarker = (location) ->
        args =
          title: project?.name, location: location
        addMarker template, args

      if location?
        addProjectMarker(location)

      GoogleMaps.init(
        {}
        ->
          map = getMap(template)
          google.maps.event.addListener map, 'click', (event) ->
            console.log('event', event, @, arguments)
            latLng = event.latLng
            location = {lat: latLng.lat(), lng: latLng.lng()}
            console.log('click', location)
            addProjectMarker(location)

            # TODO(aramk) Use the before hooks once they work.
#            existingLocation = project?.location ?= {}
#            _.extend(existingLocation, location)
#            result = Projects.update(project._id, {$set: {location: existingLocation}})

#            console.log('update project location', project, result)
      )
    hooks:
      before:
        insert: (doc, template) ->
          console.error('insert doc', doc)
          location = getMarkerLatLng(template)
          existing = doc.location ?= {}
          _.extend(existing, location)
          doc
        update: (docId, modifier, template) ->
          console.error('update doc', modifier, template)
          location = getMarkerLatLng(template)
          console.error('edit location', location)
          doc = modifier.$set || {}
          existing = doc.location ?= {}
          _.extend(existing, location)
          modifier
      formToDoc: (doc) ->
        console.error('formToDoc', doc, @)
        doc

  Form.helpers
    mapSettings: ->
      console.log('map', @)
      center: @location
