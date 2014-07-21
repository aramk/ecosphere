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
