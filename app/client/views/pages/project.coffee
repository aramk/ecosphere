TemplateClass = Template.project;

TemplateClass.helpers

  team: ->
    _.map @team, (userId) -> Users.findOne(userId)
