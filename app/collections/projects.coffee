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
    optional: true
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

@Projects = new Meteor.Collection 'project', schema: ProjectSchema
Projects.schema = ProjectSchema
Projects.allow(Collections.allowAll())

Projects.setCurrentId = (id) -> Session.set('projectId', id)
Projects.getCurrent = ->
  id = Projects.getCurrentId()
  Projects.findOne(id)
Projects.getCurrentId = -> Session.get('projectId')
