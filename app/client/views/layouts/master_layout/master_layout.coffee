# Events

Template.MasterLayout.events
  'click .action-go-home': (event, template) ->
    Router.go 'index'
    # use `event.stopImmediatePropagation()` if you want
    # to capture this at a lower level


# Helpers

Template.MasterLayout.helpers


# Lifecycle Hooks

Template.MasterLayout.created = ->

Template.MasterLayout.rendered = ->

Template.MasterLayout.destroyed = ->

