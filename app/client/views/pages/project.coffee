TemplateClass = Template.project

TemplateClass.helpers

  anyTags: -> !!@project?.tags?.length
  tags: -> @project?.tags
  team: -> _.map @team, (userId) -> Users.findOne(userId)
