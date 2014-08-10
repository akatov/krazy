root = exports ? @

root.Widgets = new Meteor.Collection 'widgets'

if Meteor.isClient

  # for positioning of new widgets
  # TODO: use a better layout algorithm
  position = 0

  Template.board.widgets = ->
    Widgets.find()

  Template.board.events
    'click #newWidget': (event) ->
      Widgets.insert
        owner: Meteor.user()
        contents: ''
        position:
          x: position
          y: position
        votes:
          Yes:[]
          No:[]
        templateId: 1
        editable: true
      position += 50

  votingTemplates = [
    id:0,
    name:"Ok", 
    opts: ["Ok"], 
    clss:["positive"]
  ,
    id:1,
    name:"Yes/No", 
    opts:["Yes","No"], 
    clss:["positive","negative"]
  ,
    id:2,
    name:"+/-/0", 
    opts:["Like","Dislike","Whatev"], 
    clss:["positive","negative","neutral"]
  ]

  mapify = (array) ->
    _.object(_.map(array,(x)->[x.id,x]))

  votingTemplatesMap = mapify(votingTemplates)

  Template.widget.votingTemplates = -> 
    temps = _.map(votingTemplates, _.clone)
    for t in temps
      t.current = (t.id == @templateId)
    temps

  Template.widget.hasVotes = ->
    for k,v of @votes
      if v.length 
        return true
    return false

  Template.widget.votesArray = ->
    uid = Meteor.user()._id
    votesArray = []
    temp = votingTemplatesMap[@templateId]
    for pair in _.zip(temp.opts,temp.clss)
      opt = pair[0]
      votesArray.push
        option:     opt
        votes:      @votes[opt] || []
        klass:      pair[1]
        widget:     @_id
        opts:       temp.opts
        userVote:   (uid in _.map(@votes[opt],(x)->x._id))      
    return votesArray 

  Template.widget.style = ->
    "left: #{ @position.x }px; top: #{ @position.y }px;"

  Template.widget.events
    'click .delete': ->
      Widgets.remove @_id

    'click .vote': (event)->
      v = $(event.target).attr("name")
      u = Meteor.user()
      
      newVote = {}
      newVote["votes."+v] = u
      
      otherVotes = {}
      for opt in @opts
        if opt!=v 
          otherVotes["votes."+opt] = 
            _id : u._id

      Widgets.update(
        _id: @widget
      ,
        $pull: otherVotes
        $addToSet: newVote
      )

    'click .unvote': (event)->
      v = $(event.target).attr("name")
      u = Meteor.user()

      prevVote = {} 
      prevVote["votes."+v] = 
        _id : u._uid
      Widgets.update(
        _id: @widget
      ,
        $pull: prevVote
      )

    'dblclick .widget-header': ->
      Widgets.update(
        _id: @_id
      ,
        $set: editable: !@editable
      )
      trySetFocus()

    # little helper for debugging purpose
    'click .widget-header': (event)->
      console.log("Logging Widget Data For Debugging (window.W)")
      console.log(@)
      window.W = @

    'change #votingTemplateSelector': (event)->
      tempId = $(event.target).val()
      emptyVotes = {}
      for opt in votingTemplatesMap[tempId].opts
        emptyVotes[opt] = []
      Widgets.update(
        _id: @_id
      ,
        $set:
          templateId: tempId
          votes: emptyVotes
      )    

    'click .save': (event, ui) ->
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

    $("#widgetContentsEditor").focus()


  trySetFocus = -> 
    # TODO: make this fucking work...
    console.log('trying $("#widgetContentsEditor").focus()')
    $("#widgetContentsEditor").focus()


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
