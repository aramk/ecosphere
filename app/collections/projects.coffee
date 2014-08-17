ProjectSchema = new SimpleSchema
# General
  name:
    label: 'Name'
    type: String,
    index: true,
    unique: true
  desc:
    label: 'Description'
    type: String
  location:
    label: 'Location'
    type: Object
    optional: true
  'location.name':
    label: 'Location Name'
    type: String
    optional: true
  'location.lat':
    label: 'Latitude'
    type: Number
    decimal: true
    optional: true
  'location.lng':
    label: 'Longitude'
    type: Number
    decimal: true
    optional: true
  summary:
    label: 'Summary'
    type: String
    optional: true
  tags:
    label: 'Tags'
    type: [String]
    optional: true

# Status
  phase:
    label: 'Phase'
    type: String
    allowedValues: ['Ideation', 'Specification', 'Business Case', 'Approval', 'Funding',
                    'Implementation', 'Scale']

# Resources
  resources:
    label: 'Resources'
    type: [Object]
    defaultValue: []

# Personnel
  team:
    label: 'Team'
    type: [Object]
    defaultValue: []
  'team.$.id':
    label: 'ID'
    type: String
  'team.$.username':
    label: 'Username'
    type: String
  'team.$.role':
    label: 'Role'
    type: String

@Projects = new Meteor.Collection 'project', schema: ProjectSchema
Projects.schema = ProjectSchema

Projects.allow(Collections.allowAll())

Projects.setCurrentId = (id) -> Session.set('projectId', id)
Projects.getCurrentId = -> Session.get('projectId')

Projects.getCurrent = ->
  Projects.findOne Projects.getCurrentId()

Projects.getOwner = (project) ->
  for member in project.team
    if member.role == 'owner' then return member

Meteor.startup ->
  Tags.TagsMixin(Projects);
  # TODO(orlade): Allow tags from core team members (just be logged in for now).
  Projects.allowTags (userId) -> !!userId

  Projects.initEasySearch ['name', 'desc', 'summary', 'tags']
