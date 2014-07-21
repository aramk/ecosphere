TemplateClass = Template.projectsWidget

# The list of projects the user is following.
TemplateClass.projects = ->
  Meteor.user().projects?.following

# Whether the user has any projects to list.
TemplateClass.anyProjects = ->
  !!Meteor.user().projects?.length
