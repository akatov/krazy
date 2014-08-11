root = exports ? @

root.Widgets = new Meteor.Collection 'widgets'

root.VotingTemplates = new Meteor.Collection 'votingTemplates'

if Meteor.isClient

  # for positioning of new widgets
  # TODO: use a better layout algorithm
  position = 0

  Template.board.widgets = ->
    Widgets.find()

  Template.board.events
    'click #newWidget': ->
      Widgets.insert
        owner: Meteor.user()
        contents: ''
        position:
          x: position
          y: position
        votes: {}
        editable: true
      position += 50

  UI.registerHelper 'arraify', (o) ->
    _.map o, (v, k) -> {key: k, value: v}

  Template.widget.votingTemplates = ->
    VotingTemplates.find()

  Template.widget.hasVotes = ->
    _.any @votes, (v) -> v.length > 0

  numVotesForWidget = (w) ->
    numVotes = 0
    for __, arr in w.votes
      numVotes += arr.length
    numVotes

  canModifyWidget = (w) ->
    w.owner._id == Meteor.userId() && numVotesForWidget(w) == 0

  canVoteOnWidget = (w) ->
    !w.editable

  isNewWidget = (w) ->
    uid = Meteor.userId()
    return false if uid == w.owner._id
    hasVoted = false
    for __, arr in w.votes
      arr.forEach (voter) ->
        if voter._id == uid
          hasVoted = true
      break if hasVoted
    !hasVoted

  Template.widget.canEdit = ->
    canModifyWidget @

  Template.widget.style = ->
    "left: #{ @position.x }px; top: #{ @position.y }px;"

  Template.widget.classes = ->
    if isNewWidget @
      'widget new'
    else
      'widget'

  Template.widget.isEditingWidget = ->
    @editable && canModifyWidget @

  Template.widget.iAmVoter = ->
    Meteor.userId() == @_id

  Template.widget.events
    'click .delete': (eventt, ui) ->
      widget = ui.data
      if canModifyWidget widget
        Widgets.remove widget._id

    'click .vote': (event, ui)->
      widget = ui.data
      return unless canVoteOnWidget widget

      v = $(event.target).attr("name")
      u = Meteor.user()
      
      newVote = {}
      newVote["votes.#{ v }"] = u
      
      Widgets.update(
        _id: widget._id
      ,
        $addToSet: newVote
      )

    'click .unvote': (event, ui)->
      widget = ui.data
      return unless canVoteOnWidget widget

      v = $(event.target).attr("name")
      uid = Meteor.userId()

      prevVotes = {}
      _.forEach widget.votes, (v, n) ->
        prevVotes["votes.#{ n }"] = 
          _id : uid
      Widgets.update(
        _id: widget._id
      ,
        $pull: prevVotes
      )

    'dblclick .widget-header': (event, ui) ->
      widget = ui.data
      return unless canModifyWidget widget

      Widgets.update(
        _id: widget._id
      ,
        $set: editable: !@editable
      )

    # little helper for debugging purpose
    'click .widget-header': (event)->
      console.log("Logging Widget Data For Debugging (window.W)")
      console.log(@)
      window.W = @

    'change #votingTemplateSelector': (event, ui) ->
      widget = ui.data
      tempId = $(event.target).val()
      return unless tempId
      t = VotingTemplates.findOne(tempId)
      r = {}
      _.each(t.opts, (v) -> r[v] = [])
      Widgets.update(
        _id: widget._id
      ,
        $set:
          votes: r
      )

    'click .save': (event, ui) ->
      widget = ui.data
      if canModifyWidget widget
        v = ui.$('textarea').val()
        Widgets.update(
          _id: widget._id
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

    $("#widgetContentsEditor").focus()

  Template.widgetContentsEditor.rendered = ->
    $('.widgetContentsEditor').focus()

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

    if VotingTemplates.find().count() == 0
      _.forEach([
        name: "OK"
        opts: ["OK"]
        clss: ["positive"]
      ,
        name: "Yes/No"
        opts: ["Yes", "No"]
        clss: ["positive","negative"]
      ,
        name: "+/-/0"
        opts: ["Like", "Dislike", "Whatev"],
        clss: ["positive", "negative", "neutral"]
      ], (t) ->
        VotingTemplates.insert t
      )
