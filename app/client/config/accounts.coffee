Meteor.startup ->
  Accounts.ui.config(passwordSignupFields: 'USERNAME_ONLY')

  AccountsEntry.config
    logo: 'images/logo.png'
    privacyUrl: '/privacy'
    termsUrl: '/terms'
    homeRoute: '/'
    dashboardRoute: '/dashboard'
    profileRoute: 'profile'
    # passwordSignupFields: 'EMAIL_ONLY'
    showSignupCode: false
