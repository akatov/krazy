Users = new Meteor.Collection 'users'

Widgets = new Meteor.Collection 'widgets'

# horrible hack to simulate currently logged in user
# TODO: use Meteor user management
cUser = new Meteor.Collection 'cUser'

getBruno = -> Users.findOne name: 'Bruno'
getDmitri = -> Users.findOne name: 'Dmitri'
getCurrent = -> cUser.findOne()

if Meteor.isClient

  Template.application.user = ->
    getCurrent()

  Template.application.events
    'click .logout': ->
      u = getCurrent()
      b = getBruno()
      d = getDmitri()
      cUser.remove u._id
      if u._id == b._id
        cUser.insert d
      else
        cUser.insert b

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
      Widgets.remove @_id

    'click .yes': ->
      u = getCurrent()
      Widgets.update(
        _id: @_id
      ,
        $pull: 'votes.no': _id: u._id
        $addToSet: 'votes.yes': u
      )

    'click .no': ->
      u = getCurrent()
      Widgets.update(
        _id: @_id
      ,
        $pull: 'votes.yes': _id: u._id
        $addToSet: 'votes.no': u
      )

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
    cUser.remove _id: $exists: true

    if Users.find().count() == 0
      Users.insert user for user in [
        avatar : 'https://pbs.twimg.com/profile_images/378800000516083066/ea020e7822f1a0cd3bde21a0bb444cc7_400x400.jpeg'
        name: 'Bruno'
      ,
        name: 'Dmitri'
        avatar: 'https://avatars3.githubusercontent.com/u/1148449'
      ]
    bruno = getBruno()
    dmitri = getDmitri()

    cUser.insert bruno

    # include the full user object for now
    if Widgets.find().count() == 0
      Widgets.insert widget for widget in [
        owner: bruno
        contents: 'I think this board is awesome.'
        position:
          x: 0
          y: 0
        votes:
          yes: [bruno, dmitri]
          no: []
      ,
        owner: dmitri
        contents: 'I think Ember.JS is cool.'
        position:
          x: 200
          y: 0
        votes:
          yes: [bruno]
          no: [dmitri]
      ,
        owner: bruno
        contents: 'I think meteor is cool.'
        position:
          x: 0
          y: 200
        votes:
          yes: [dmitri]
          no: [bruno]
      ,
        owner: dmitri
        contents: 'I think famo.us is amazing!'
        position:
          x: 200
          y: 200
        votes:
          yes: [dmitri]
          no: []
      ]
