Users = new Meteor.Collection 'users'

Widgets = new Meteor.Collection 'widgets'

if Meteor.isClient

  Template.application.user = ->
    Users.findOne()

  Template.application.events
    'click .logout': ->
      console.log 'logging out'

  Template.board.widgets = ->
    Widgets.find()

  Template.board.events
    'keypress #magicBar': (event) ->
      if event.charCode == 13
        console.log 'pressed enter'

  Template.widget.style = ->
    "left: #{ @position.x }px; top: #{ @position.y }px;"

  Template.widget.events
    'click .delete': ->
      console.log 'deleting widget'

  Template.widget.rendered = ->
    onDragOrStop = (event, ui) =>
      p = ui.position
      Widgets.update @data._id, $set: position: { x: p.left, y: p.top }

    $(@find '.widget').draggable
      handle: '.widget-header'
      cancel: '.widget-header button'
      drag: onDragOrStop
      stop: onDragOrStop

if Meteor.isServer
  Meteor.startup ->

    # always clean collections at startup for now
    Users.remove _id: $exists: true
    Widgets.remove _id: $exists: true

    if Users.find().count() == 0
      Users.insert
        avatar : 'https://pbs.twimg.com/profile_images/378800000516083066/ea020e7822f1a0cd3bde21a0bb444cc7_400x400.jpeg'
        name: 'Bruno'
    user = Users.findOne()

    # include the full user object for now
    if Widgets.find().count() == 0
      Widgets.insert widget for widget in [
        owner: user
        contents: 'I think this board is awesome.'
        position:
          x: 0
          y: 0
      ,
        owner: user
        contents: 'I think Ember.JS is cool.'
        position:
          x: 200
          y: 0
      ,
        owner: user
        contents: 'I think meteor is cool.'
        position:
          x: 0
          y: 200
      ,
        owner: user
        contents: 'I think famo.us is amazing!'
        position:
          x: 200
          y: 200
      ]
