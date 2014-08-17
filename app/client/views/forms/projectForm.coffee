TemplateClass = Template.projectForm

TemplateClass.rendered = ->
  # If there is no phase saved, select the first one by default.
  unless this.data.doc?.phase? then $('input[name="phase"]').first().click()

TemplateClass.helpers
  phaseOptions: -> Projects.schema._schema.phase.allowedValues


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

    onCancel: close

    onSuccess: close

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
      )
    hooks:
      before:
        insert: (doc, template) ->
          # Ensure the owner is saved to the team.
          doc.team ?= []
          doc.team.push(
            id: Meteor.userId()
            username: Meteor.user().username
            role: 'owner'
          )
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
