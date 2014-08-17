TemplateClass = Template.projectMap

TemplateClass.rendered = ->
  data = @data ?= {}
  settings = _.defaults(data,
    center: {lat: -37.7968056, lng: 144.9613277}
    type: 'STREET'
    zoom: 17
  )
  mapNode = @find('.map')

  GoogleMaps.init(
    -> {
#    sensor: true, # optional
#    'key': 'MY-GOOGLEMAPS-API-KEY' # optional
#    'language': 'de' # optional
    }
    ->
      mapOptions =
        zoom: settings.zoom,
        mapTypeId: google.maps.MapTypeId[settings.type]
      map = new google.maps.Map(mapNode, mapOptions)
      map.setCenter(new google.maps.LatLng(settings.center.lat, settings.center.lng))
      $(mapNode).data('gmap', map)
  )
