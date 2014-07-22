var TAG_LIMIT = 7;

// Returns the collection to which the given data object belongs.
// TODO(orlade): Use more sophisticated method.
function getCollection(data) {
  if (data.username) {
    return Users;
  } else {
    return Projects;
  }
}

Template.tagInput.rendered = function () {
  Collection = getCollection(this.data);
  var that = this;
  this.$('.tag-input').selectize({
    valueField: 'name',
    labelField: 'name',
    searchField: ['name'],
    create: function(input, cb) {
      Collection.addTag(input, {_id: that.data._id});
      var tag =  Meteor.tags.findOne({collection: Collection._name, name: input});

      if (cb) {
        cb(tag);
      }

      return tag;
    },
    options: Meteor.tags.find({}, {limit: TAG_LIMIT}).fetch(),
    render: {
      item: function(item, escape) {
        return '<div>' +
            (item.name ? '<span class="name">' + escape(item.name) + '</span>' : '') +
            '</div>';
      },
      option: function(item, escape) {
        var name = item.name;
        var caption = item.nRefs;
        return '<div>' +
            '<span class="name">' + escape(name) + '</span>&nbsp;' +
            (caption ? '<span class="badge">' + escape(caption) + '</span>' : '') +
            '</div>';
      }
    },
    onItemAdd: function(value, $item) {
      Collection.addTag(value, {_id: that.data._id});
    },
    onItemRemove: function(value) {
      Collection.removeTag(value, {_id: that.data._id});
    }
  });
};
