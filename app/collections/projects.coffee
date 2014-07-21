ProjectSchema = new SimpleSchema
  name:
    label: 'Name'
    type: String,
    index: true,
    unique: true
  desc:
    label: 'Description'
    type: String
    optional: true

@Projects = new Meteor.Collection 'project', schema: ProjectSchema
Projects.schema = ProjectSchema
Projects.allow(Collections.allowAll())

Projects.setCurrentId = (id) -> Session.set('projectId', id)
Projects.getCurrent = ->
  id = Projects.getCurrentId()
  Projects.findOne(id)
Projects.getCurrentId = -> Session.get('projectId')
