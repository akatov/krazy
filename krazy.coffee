root = exports ? @

root.Widgets = new Meteor.Collection 'widgets'

if Meteor.isClient

  # for positioning of new widgets
  # TODO: use a better layout algorithm
  position = 0

  Template.board.widgets = ->
    Widgets.find()

  Template.board.events
    'keypress #magicBar': (event) ->
      t = $(event.target)
      if event.charCode == 13
        value = t.val()
        if value.length > 0
          Widgets.insert
            owner: Meteor.user()
            contents: value
            position:
              x: position
              y: position
            votes:
              yes: []
              no: []
          position += 50
          t.val('')

  canModifyWidget = (w) ->
    w.owner._id == Meteor.user()._id && w.votes.yes.length == 0 && w.votes.no.length == 0

  canVoteOnWidget = (w) ->
    !w.editable

  Template.widget.style = ->
    "left: #{ @position.x }px; top: #{ @position.y }px;"

  Template.widget.canEdit = ->
    canModifyWidget @

  Template.widget.events
    'click .delete': ->
      if canModifyWidget @
        Widgets.remove @_id

    'click .yes': ->
      if canVoteOnWidget @
        u = Meteor.user()
        Widgets.update(
          _id: @_id
        ,
          $pull: 'votes.no': _id: u._id
          $addToSet: 'votes.yes': u
        )

    'click .no': ->
      if canVoteOnWidget @
        u = Meteor.user()
        Widgets.update(
          _id: @_id
        ,
          $pull: 'votes.yes': _id: u._id
          $addToSet: 'votes.no': u
        )

    'dblclick .widget-header': ->
      if canModifyWidget @
        Widgets.update(
          _id: @_id
        ,
          $set: editable: !@editable
        )

    'click .save': (event, ui) ->
      if canModifyWidget @
        v = ui.$('textarea').val()
        Widgets.update(
          _id: @_id
        ,
          $set:
            contents: v
            editable: false
        )

  Template.widget.rendered = ->
    onDragOrStop = (event, ui) =>
      p = ui.position
      Widgets.update @data._id, $set: position: { x: p.left, y: p.top }

    @$('.widget').draggable
      handle: '.widget-header'
      cancel: '.widget-header button'
      drag: onDragOrStop
      stop: onDragOrStop

if Meteor.isServer

  Meteor.startup ->

    # use facebook picture as avatar
    Accounts.onCreateUser (opts, user) ->
      if opts.profile
        opts.profile.avatar = "http://graph.facebook.com/#{ user.services.facebook.id }/picture/?type=square"
        user.profile = opts.profile
      user

    # always clean Widgets collection at startup for now
    Widgets.remove _id: $exists: true
