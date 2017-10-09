`import Ember from 'ember'`
`import {languages} from '../utils/languages'`
`import env from '../config/environment'`

SetLanguageController = Ember.Controller.extend
  session: Ember.inject.service('session')
  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  languageOptions: languages
  actions:
    setLanguage: (lang) ->
      user = @get('user')
      user.set('language', lang.id)
      user.save().then(=>
        @transitionToRoute('concepts', env.etms.occupationScheme)
      )
`export default SetLanguageController`
