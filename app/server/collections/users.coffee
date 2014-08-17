# Override the createUser method to ensure new users have a valid username.
Accounts.createUser = _.wrap(Accounts.createUser, (createUser) ->
  user = _.toArray(arguments).slice(1)[0]
  user.username ?= user.email.split('@')[0]
  createUser user
)
