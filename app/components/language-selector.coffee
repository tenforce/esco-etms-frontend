`import Ember from 'ember'`
`import {languages} from '../utils/languages'`

LanguageSelectorComponent = Ember.Component.extend
  languageOptions: Ember.computed 'languages', ->
    languages.sort (a, b) ->
      if a.title < b.title then return -1
      if a.title > b.title then return 1
      return 0
  language: Ember.computed 'defaultLang', ->
    languages.findBy('id', @get('defaultLang'))
  actions:
    setLanguage: (lang) ->
      @set 'language', lang
      @sendAction('setLanguage', lang)

`export default LanguageSelectorComponent`
