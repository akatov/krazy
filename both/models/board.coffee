class @Board extends Minimongoid

  @_collection: new Meteor.Collection 'boards'

  @has_many: [
    name: 'widgets'
    foreign_key: 'board_id'
  ]
