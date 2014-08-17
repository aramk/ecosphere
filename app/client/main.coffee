# General setup for the project.

Meteor.startup ->
  AccountsEntry.config
    logo: 'images/logo.png'
    privacyUrl: '/privacy'
    termsUrl: '/terms'
    homeRoute: '/'
    dashboardRoute: '/dashboard'
    profileRoute: 'profile'
#    passwordSignupFields: 'EMAIL_ONLY'
    showSignupCode: false
