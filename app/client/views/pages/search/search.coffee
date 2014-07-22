TemplateClass = Template.search

$searchInput = null

TemplateClass.helpers
  indexes: -> ['project', 'user']

changeQuery = (query) ->
  if query? then $searchInput.val(query).trigger('keyup')

TemplateClass.rendered = ->
  console.debug('render', @data)
  $searchInput = $(@.find('.search-input')).focus()
  changeQuery @data?.query

TemplateClass.events
  # Update the URL string whenever the query value changes.
  'input .search-input': ->
    queryValue = $searchInput.val()
    options = replaceState: true
    if queryValue then options['query'] = query: queryValue
    Router.go 'search', {}, options

  # Manually update the query value when a tag is clicked.
  'click .tag-label': ->
    changeQuery this

