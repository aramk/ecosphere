TemplateClass = Template.search

TemplateClass.helpers
  indexes: -> ['project', 'user']

TemplateClass.rendered = ->
  $searchInput = $(@.find('.search-input')).focus()
  if @data?.query? then $searchInput.val(@data.query).trigger('keyup')

TemplateClass.events
  # Update the URL string whenever the query value changes.
  'input .search-input': ->
    queryValue = $('.search-input').val()
    options = replaceState: true
    if queryValue then options['query'] = query: queryValue
    Router.go 'search', {}, options

