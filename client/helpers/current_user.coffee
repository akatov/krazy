UI.registerHelper 'currentUserId', ->
  User.currentId()

UI.registerHelper 'currentUser', ->
  User.current()
