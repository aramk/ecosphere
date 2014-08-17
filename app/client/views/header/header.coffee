TemplateClass = Template.header

followLink = (evt) ->
  Router.go($(evt.target).attr('href'))
  # TODO(orlade): Figure out why this is necessary too.
  setTimeout (-> $('.menu.open').removeClass('open')), 1

TemplateClass.rendered = ->
  $('.ui.dropdown').dropdown()
  $('.profile.menu > a.item').click(followLink)

TemplateClass.events
  # Manually update the .active state on the main menu items.
  'click .main.menu > a.item': (evt) ->
    $('.main.menu .item').removeClass('active')
    $(evt.target).addClass('active')

  # TODO(orlade): Figure out why these don't work.
  # Presumably the items are reconstructed in dropdown()?

  # Manually follow links in the profile dropdown menu.
  #  'click .profile.menu > a.item': (evt) ->
  #    console.debug 'clicked', evt.target
  #    Router.go($(evt.target).attr('href'))
  #
  #  'click .profile.item': (evt) ->
  #    console.debug 'clicked', evt.target

