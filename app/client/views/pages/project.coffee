TemplateClass = Template.project;

TemplateClass.anyTags = -> !!@project?.tags?.length

TemplateClass.tags = -> @project?.tags

#TemplateClass.rendered = ->
#  $('select').selectize();
