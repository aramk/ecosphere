Meteor.methods
  loadHelp: (category, topic) ->
    if category == 'index' then return ['phases', 'resources']
    if category == 'phases' then return Assets.getText('help/phases.md')
    if category == 'resources' then return Assets.getText('help/resources.md')
