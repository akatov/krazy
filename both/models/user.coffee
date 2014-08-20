class @User extends Minimongoid

  @_collection: Meteor.users

  @currentId: ->
    Meteor.userId()

  @current: ->
    User.init Meteor.user() if Meteor.userId()

  @online: ->
    @where({'status.online': true, _id: {$ne: Meteor.userId()}})

  avatar: ->
    @profile.avatar

  name: ->
    @profile.name
