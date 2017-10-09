`import Ember from 'ember';`
`import config from './config/environment';`

Router = Ember.Router.extend
  location: config.locationType

unless config.baseURL == "/"
  Ember.$.ajaxSetup
    beforeSend: (xhr, options) ->
      options.url = config.baseURL + options.url;

Router.map ->
  @route 'concepts', { path: 'concepts/:taxonomy' }, ->
    @route 'show', { path: ':id' }
    @route 'create'
  @route 'sign-in'
  @route 'menu', ->
    @route 'profile'
    @route 'bookmarks'
    @route 'notifications', { path: 'notifications/:display'}
    @route 'validation'
    @route 'dashboard', { path: 'dashboard/:display'}
    @route 'publications'
    @route 'officialize-publication', {path: 'publications/:id'}
    @route 'create-publication'
    @route 'loading'
  @route 'gobbler', { path: '/*wildcard' }
  @route 'export'

`export default Router;`
