if Meteor.isClient

  user = {
    avatar : 'https://pbs.twimg.com/profile_images/378800000516083066/ea020e7822f1a0cd3bde21a0bb444cc7_400x400.jpeg'
    name: 'Bruno'
  }

  Template.user.avatar = -> user.avatar
  Template.user.name = -> user.name

  Template.board.owner = -> user

  Template.board.contents = 'I think this board is awesome.'

  Template.board.events
    'click input': ->
      if typeof console != 'undefined'
        console.log "You pressed the button"

if Meteor.isServer
  Meteor.startup ->
