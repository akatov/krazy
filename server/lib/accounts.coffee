Meteor.startup ->

  # use facebook picture as avatar
  Accounts.onCreateUser (opts, user) ->
    user.profile = {} unless user.profile
    if opts.profile && user.services.facebook
      avatar = 'http://graph.facebook.com/'
      avatar += user.services.facebook.id
      avatar += '/picture/?type=square'
      opts.profile.avatar = avatar
      user.profile = opts.profile
    else if user.services.google
      user.profile.avatar = user.services.google.picture
      user.profile.name = user.services.google.name
    user
