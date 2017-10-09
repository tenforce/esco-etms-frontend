`import Ember from 'ember'`

CurrentUserService = Ember.Service.extend
  session: Ember.inject.service('session')
  store: Ember.inject.service('store')
  init: ->
    @_super(arguments...)
    # try get the current user, for if the user is still logged in through cookie
    @ensureUser()
  sessionAuthenticated: ->
    @ensureUser()
  sessionInvalidated: ->
    @set 'user', null

  userInGroup: (groupName) ->
    valid= false
    @get('groups')?.forEach (group) ->
      if group.get('name') is groupName
        valid= true
    return valid

  userIsTranslator: Ember.computed 'user', 'groups', ->
    @userInGroup('EMPL_ESCOETM') or @userInGroup('EMPL_ESCOETMT')
  userIsReviewer: Ember.computed 'user', 'groups', ->
    @userInGroup('EMPL_ESCOETMVIS') or @userInGroup('EMPL_ESCOETMVIT')
  userIsAdmin: Ember.computed 'user', 'groups', ->
    true # Comment out the line below for ultimate power
    @userInGroup('EMPL_ESCOETMADM') or @userInGroup('EMPL_ESCOETMADT')

  disableShortcuts: Ember.computed 'user.disableShortcuts', ->
    disable = @get('user.disableShortcuts')
    if disable is "yes" then return true
    else return false

  ensureUser: ->
    new Ember.RSVP.Promise (resolve, reject) =>
      accountId = @get('session.data.authenticated.relationships.account.data.id')
      if Ember.isEmpty(accountId)
        reject()
      else if @get('user')
        resolve()
      else
        setUser = ((user) =>
          @set('user', user)
          #@set('user.language', 'hu')
          @set('user.language', 'en')
          # TODO set it to english when we have english tasks!!!
          resolve())
        @get('store').find('account', accountId).then( (account) =>
          account.get('user').then (user) =>
            user.get('groups').then (groups) =>
              @set 'groups', groups
              setUser(user)
        ).catch(reject)

`export default CurrentUserService`
