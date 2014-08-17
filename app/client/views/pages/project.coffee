TemplateClass = Template.project

console.debug Router.routes

TemplateClass.helpers

  anyTags: -> !!@project?.tags?.length
  tags: -> @project?.tags
  team: -> _.map @team, (userId) -> Users.findOne(userId)
