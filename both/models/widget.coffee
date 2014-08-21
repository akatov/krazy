class @Widget extends Minimongoid

  @_collection: new Meteor.Collection 'widgets'

  @belongs_to: [
    name: 'board'
  ,
    name: 'owner'
    class_name: 'User'
  ]
