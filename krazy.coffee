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
  ,
    owner: user
    contents: 'I think Ember.JS is cool.'
  ,
    owner: user
    contents: 'I think meteor is cool.'
  ,
    owner: user
    contents: 'I think famo.us is amazing!'
  ]

  Template.board.events
    'keypress #magicBar': (event) ->
      if event.charCode == 13
        console.log 'pressed enter'

  Template.widget.events
    'click .delete': ->
      console.log 'deleting widget'

if Meteor.isServer
  Meteor.startup ->
