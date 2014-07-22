ProjectSchema = new SimpleSchema
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
  'location.lat':
    label: 'Latitude'
    type: Number
    decimal: true
  'location.lng':
    label: 'Longitude'
    type: Number
    decimal: true
  summary:
    label: 'Summary'
    type: String
    optional: true
  team:
    label: 'Team'
    type: [String]
    defaultValue: []
  tags:
    label: 'Tags'
    type: [String]
    optional: true

@Projects = new Meteor.Collection 'project', schema: ProjectSchema
Projects.schema = ProjectSchema

Projects.allow(Collections.allowAll())

Projects.setCurrentId = (id) -> Session.set('projectId', id)
Projects.getCurrentId = -> Session.get('projectId')

Projects.getCurrent = ->
  Projects.findOne Projects.getCurrentId()

Meteor.startup ->
  Tags.TagsMixin(Projects);
  # TODO(orlade): Allow tags from core team members (just be logged in for now).
  Projects.allowTags (userId) -> !!userId

  Projects.initEasySearch ['name', 'desc', 'summary', 'tags'],
    'limit' : 20
