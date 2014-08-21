Meteor.publish null, ->
  Meteor.users.find(
    {'status.online': true }
    {fields: {'status.online': 1}}
  )
