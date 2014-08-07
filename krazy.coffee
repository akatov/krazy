if Meteor.isClient
  Template.hello.greeting = -> "Welcome to krazy."

  Template.hello.events
    'click input': ->
      if typeof console != 'undefined'
        console.log "You pressed the button"

if Meteor.isServer
  Meteor.startup ->
