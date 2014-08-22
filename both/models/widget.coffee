class @Widget extends Minimongoid

  @_collection: new Meteor.Collection 'widgets'

  @belongs_to: [
    name: 'board'
  ,
    name: 'owner'
    class_name: 'User'
  ]

  @embeds_many: [
    name: 'votes'
  ]

class @Vote extends Minimongoid

  @embedded_in: 'widget'

  @belongs_to: [
    name: 'user'
  ]
