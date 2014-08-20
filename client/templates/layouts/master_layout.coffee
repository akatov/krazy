# Helpers

Template.MasterLayout.helpers
  OnlineUsers: ->
    Meteor.users.find({'status.online': true, _id: {$ne: Meteor.userId()}})


# Lifecycle Hooks

Template.MasterLayout.created = ->

Template.MasterLayout.rendered = ->

Template.MasterLayout.destroyed = ->

