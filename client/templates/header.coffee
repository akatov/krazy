Template.Header.events
  'click .action-go-home': (event, template) ->
    Router.go 'index'
    # use `event.stopImmediatePropagation()` if you want
    # to capture this at a lower level

  'click .action-logout': (event, template) ->
    Meteor.logout()
