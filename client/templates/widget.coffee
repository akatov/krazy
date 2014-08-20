# Helper functions

numVotesForWidget = (w) ->
  numVotes = 0
  for __, arr in w.votes
    numVotes += arr.length
  numVotes

canModifyWidget = (w) ->
  w.owner._id == User.currentId() && numVotesForWidget(w) == 0

canVoteOnWidget = (w) ->
  !w.editable

isNewWidget = (w) ->
  uid = User.currentId()
  return false if uid == w.owner._id
  _.all w.votes, (v, k) -> k != uid


# Helpers

Template.Widget.helpers

  votingTemplates: ->
    VotingTemplates.find()

  voteLines: ->
    me_id = User.currentId()
    _.map @voteOptions, (s) => {
      name: s
      voters: _.chain(@votes)
        .pairs()
        .filter((kv) -> kv[1] == s)
        .map((kv) ->
          u = User.find kv[0]
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

  hasVotes: ->
    _.any @votes, (v) -> v.length > 0

  isEditingWidget: ->
    @editable && canModifyWidget @

  style: ->
    "left: #{ @position.x }px; top: #{ @position.y }px;"

  classes: ->
    if isNewWidget @
      'widget new'
    else
      'widget'


# Events

Template.Widget.events

  'click .action-delete': (event, template) ->
    widget = template.data
    if canModifyWidget widget
      Widgets.remove widget._id

  'click .action-vote': (event, template)->
    widget = template.data
    return unless canVoteOnWidget widget

    v = $(event.target).attr("name")
    uid = User.currentId()

    Widgets.update(
      _id: widget._id
    ,
      $set: _.object([["votes.#{uid}", v]])
    )

  'click .voter.me': (event, template)->
    widget = template.data
    return unless canVoteOnWidget widget

    uid = User.currentId()

    Widgets.update(
      _id: widget._id
    ,
      $unset: _.object([["votes.#{uid}", '']])
    )

  'dblclick .action-edit': (event, template) ->
    widget = template.data
    return unless canModifyWidget widget

    Widgets.update(
      _id: widget._id
    ,
      $set: editable: !@editable
    )

  'click .action-select-template': (event, template) ->
    widget = template.data
    tempId = $(event.target).val()
    return unless tempId
    t = VotingTemplates.findOne(tempId)
    Widgets.update(
      _id: widget._id
    ,
      $set:
        voteOptions: t.opts
    )

  'click .action-save': (event, template) ->
    widget = template.data
    if canModifyWidget widget
      v = template.$('textarea').val()
      Widgets.update(
        _id: widget._id
      ,
        $set:
          contents: v
          editable: false
      )


# Widget: Lifecycle Hooks

Template.Widget.created = ->

Template.Widget.rendered = ->

  onDragOrStop = (event, ui) =>
    p = ui.position
    Widgets.update @data._id, $set: position: { x: p.left, y: p.top }

  @$('.widget').draggable
    handle: '.widget-header'
    cancel: '.widget-header button'
    drag: onDragOrStop
    stop: onDragOrStop

  $("#widgetContentsEditor").focus()

Template.Widget.destroyed = ->


# WidgetContentsEditor

Template.WidgetContentsEditor.rendered = ->
  @$('.widget-contents-editor').focus()
