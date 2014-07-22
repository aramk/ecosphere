TemplateClass = Template.search

TemplateClass.rendered = ->
  $searchInput = $(@.find('.search-input')).focus()
  if @data?.query? then $searchInput.val(@data.query).trigger('keyup')

TemplateClass.events
  # Update the URL string whenever the query value changes.
  'input .search-input': ->
    Router.go 'search', {},
      replaceState: true
      query: {query: $('.search-input').val()}
