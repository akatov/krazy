# Helper functions

numVotesForWidget = (w) ->
  numVotes = 0
  for __, arr in w.votes
    numVotes += arr.length
  numVotes

canModifyWidget = (w) ->
  w.owner_id == User.currentId() && numVotesForWidget(w) == 0

canVoteOnWidget = (w) ->
  !w.editable

isNewWidget = (w) ->
  uid = User.currentId()
  return false if uid == w.owner_id
  _.all w.votes, (v) -> v.user_id != uid


# Helpers

Template.Widget.helpers

  votingTemplates: ->
    VotingTemplate.find()

  voteLines: ->
    me_id = User.currentId()
    _.map @voteOptions, (s) => {
      name: s
      voters: _.chain(@votes)
        .filter((vote) -> vote.value == s)
        .map((vote) ->
          u = User.find vote.user_id
          {
            _id: u.id
            name: u.profile.name
            avatar: u.profile.avatar
            klass: if me_id == u.id then 'me' else ''
          }
        )
        .sortBy((u) -> u.id != me_id) # false comes before true
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
      widget.destroy()

  'click .action-vote': (event, template)->
    widget = template.data
    return unless canVoteOnWidget widget

    v = $(event.target).attr("name")
    uid = User.currentId()

    # TODO: see whether there's a single operation for this
    widget.constructor._collection.update widget.id,
      $pull: {votes: {user_id: uid}}
    widget.push votes: { user_id: uid, value: @name }

  'click .voter.me': (event, template)->
    widget = template.data
    return unless canVoteOnWidget widget

    uid = User.currentId()
    widget.constructor._collection.update widget.id,
      $pull: {votes: {user_id: uid}}

  'dblclick .action-edit': (event, template) ->
    widget = template.data
    return unless canModifyWidget widget

    widget.update editable: !@editable

  'click .action-select-template': (event, template) ->
    widget = template.data
    tempId = $(event.target).val()
    return unless tempId
    t = VotingTemplate.first tempId
    widget.update voteOptions: t.opts

  'click .action-save': (event, template) ->
    widget = template.data
    if canModifyWidget widget
      v = template.$('textarea').val()
      widget.update
        contents: v
        editable: false

# Widget: Lifecycle Hooks

Template.Widget.created = ->

Template.Widget.rendered = ->

  onDragOrStop = (event, ui) =>
    p = ui.position
    widget = Widget.first @data.id
    widget.update position: { x: p.left, y: p.top }

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
