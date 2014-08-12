Meteor.startup ->

  # use facebook picture as avatar
  Accounts.onCreateUser (opts, user) ->
    if opts.profile
      avatar = 'http://graph.facebook.com/'
      avatar += user.services.facebook.id
      avatar += '/picture/?type=square'
      opts.profile.avatar = avatar
      user.profile = opts.profile
    user
