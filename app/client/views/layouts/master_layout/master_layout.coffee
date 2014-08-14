# Events

Template.MasterLayout.events
  'click .action-go-home': (event, template) ->
    Router.go 'index'
    # use `event.stopImmediatePropagation()` if you want
    # to capture this at a lower level


# Helpers

Template.MasterLayout.helpers
  OnlineUsers: ->
    Meteor.users.find({'status.online': true, _id: {$ne: Meteor.userId()}})


# Lifecycle Hooks

Template.MasterLayout.created = ->

Template.MasterLayout.rendered = ->

Template.MasterLayout.destroyed = ->

