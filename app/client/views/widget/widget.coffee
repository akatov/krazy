# Helper functions

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
  _.all w.votes, (v, k) -> k != uid


# Template Variables

Template.widget.votingTemplates = ->
  VotingTemplates.find()

Template.widget.voteLines = ->
  me_id = Meteor.userId()
  _.map @voteOptions, (s) => {
    name: s
    voters: _.chain(@votes)
      .pairs()
      .filter((kv) -> kv[1] == s)
      .map((kv) ->
        u = Meteor.users.findOne(kv[0])
        {
          _id: u._id
          name: u.profile.name
          avatar: u.profile.avatar
          klass: if me_id == u._id then 'me' else ''
        }
      )
      .sortBy((u) -> u._id != me_id) # false comes before true
      .value()
  }

Template.widget.hasVotes = ->
  _.any @votes, (v) -> v.length > 0

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


# Events

Template.widget.events

  'click .delete': (eventt, ui) ->
    widget = ui.data
    if canModifyWidget widget
      Widgets.remove widget._id

  'click .vote': (event, ui)->
    widget = ui.data
    return unless canVoteOnWidget widget

    v = $(event.target).attr("name")
    uid = Meteor.userId()

    Widgets.update(
      _id: widget._id
    ,
      $set: _.object([["votes.#{uid}", v]])
    )

  'click .voter.me': (event, ui)->
    widget = ui.data
    return unless canVoteOnWidget widget

    uid = Meteor.userId()

    Widgets.update(
      _id: widget._id
    ,
      $unset: _.object([["votes.#{uid}", '']])
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

  'click .votingTemplate': (event, ui) ->
    widget = ui.data
    tempId = $(event.target).val()
    return unless tempId
    t = VotingTemplates.findOne(tempId)
    Widgets.update(
      _id: widget._id
    ,
      $set:
        voteOptions: t.opts
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


# Helpers

Template.widget.helpers
# Example:
#   items: ->
#


# Widget: Lifecycle Hooks

Template.widget.created = ->

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

Template.widget.destroyed = ->


  # widgetContentsEditor

Template.widgetContentsEditor.rendered = ->
  $('.widgetContentsEditor').focus()
