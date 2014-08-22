class @User extends Minimongoid

  @_collection: Meteor.users

  @has_many: [
    name: 'widgets'
    foreign_key: 'owner_id'
  ]

  @currentId: ->
    Meteor.userId()

  @current: ->
    User.init Meteor.user() if Meteor.userId()

  @online: ->
    @where({'status.online': true, _id: {$ne: Meteor.userId()}})

  @property 'avatar',
    get: ->
      @profile?.avatar

  @property 'name',
    get: ->
      @profile?.name
