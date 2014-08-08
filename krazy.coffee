if Meteor.isClient

  user = {
    avatar : 'https://pbs.twimg.com/profile_images/378800000516083066/ea020e7822f1a0cd3bde21a0bb444cc7_400x400.jpeg'
    name: 'Bruno'
  }

  Template.application.user = -> user

  Template.application.events
    'click .logout': ->
      console.log 'logging out'

  Template.board.widgets = -> [
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

  Template.board.events
    'keypress #magicBar': (event) ->
      if event.charCode == 13
        console.log 'pressed enter'

  Template.widget.style = ->
    "left: #{ @position.x }px; top: #{ @position.y }px;"

  Template.widget.events
    'click .delete': ->
      console.log 'deleting widget'

if Meteor.isServer
  Meteor.startup ->
