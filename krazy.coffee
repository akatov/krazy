root = exports ? @

root.Widgets = new Meteor.Collection 'widgets'

if Meteor.isClient

  # for positioning of new widgets
  # TODO: use a better layout algorithm
  position = 0

  Session.set 'showNewWidgetForm', false

  votingTemplates = [
    { name:'Yes/No',  options:['Yes','No']  },
    { name:"Ok",      options:["Ok"]        },
    { name:"A/B/C",   options:["A","B","C"] }
  ]

  Session.set 'votingTemplates', votingTemplates

  setTemplate = (name) ->
    Session.set 'selectedTemplate', name
    options = votingTemplates.filter((x) => x.name == name)[0].options
    Session.set 'votingOptions', options 

  setTemplate('Yes/No')   # set default template

  Template.board.widgets = ->
    Widgets.find()

  Template.board.showNewWidgetForm = ->
    Session.get 'showNewWidgetForm'

  Template.newWidgetForm.votingTemplates = ->
    Session.get 'votingTemplates'

  Template.newWidgetForm.votingOptions = ->
    Session.get 'votingOptions'

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
    'click #addNewWidget': (event) -> 
      Session.set 'showNewWidgetForm', true

  Template.newWidgetForm.events

    'click #cancelNewWidget': (event) ->
      Session.set 'showNewWidgetForm', false

    'click button.templateSelect': (event) ->
      name = $(event.target).attr("name")
      setTemplate(name)

    'click button.newVoteOption': (event) ->
      options = Session.get 'votingOptions'
      options.push ''
      Session.set 'votingOptions', options

    'click button.newVoteOption': (event) ->
      options = Session.get 'votingOptions'
      options.push ''
      Session.set 'votingOptions', options

    'click button.deleteVoteOption': (event) ->
      name = $(event.target).attr("name")
      options = Session.get 'votingOptions'
      options = options.filter((x)=> x!=name)
      Session.set 'votingOptions', options

  Template.widget.style = ->
    "left: #{ @position.x }px; top: #{ @position.y }px;"

  Template.widget.events
    'click .delete': ->
      Widgets.remove @_id

    'click .yes': ->
      u = Meteor.user()
      Widgets.update(
        _id: @_id
      ,
        $pull: 'votes.no': _id: u._id
        $addToSet: 'votes.yes': u
      )

    'click .no': ->
      u = Meteor.user()
      Widgets.update(
        _id: @_id
      ,
        $pull: 'votes.yes': _id: u._id
        $addToSet: 'votes.no': u
      )

    'dblclick .widget-header': ->
      Widgets.update(
        _id: @_id
      ,
        $set: editable: !@editable
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
