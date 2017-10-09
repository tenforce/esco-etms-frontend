`import Ember from 'ember'`
`import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin'`
`import EnsureLanguageSetMixin from '../../mixins/ensure-language-set'`

ConceptsShowRoute = Ember.Route.extend AuthenticatedRouteMixin, EnsureLanguageSetMixin,
  currentUser: Ember.inject.service()
  hierarchyService: Ember.inject.service()
  saveAllButton: Ember.inject.service()

  disableShortcuts: Ember.computed.alias 'currentUser.disableShortcuts'
  user: Ember.computed.alias 'currentUser.user'
  pathToQuest: Ember.computed 'model.id', 'user.language',  ->
    target = @get('user.language').toUpperCase()
    source = "EN"
    @modelFor(@routeName).get('defaultPrefLabel').then (label) ->
      "https://webgate.ec.testa.eu/questmetasearch/search.php?searchedText=#{label}&selectedSourceLang=#{source}&selectedDestLang=#{target}"

  beforeModel: ->
    @set('hierarchyService.loading', true)
  model: (params) ->
    options ={}
    @store.findOneQuery('concept', params.id, options)
  afterModel: (model) ->
    @get('saveAllButton').clearSubscribers()
    @set 'hierarchyService.target', Ember.get(model, 'id')
    @set('hierarchyService.loading', false)
    Ember.RSVP.all(['prefLabels', 'hiddenLabels', 'altLabels'].map (prop) -> model.get(prop)).then ->
      window.scrollTo(0, 0);

  actions:
    willTransition: (transition) ->
      if @get('saveAllButton.dirty') && !confirm("You have unsaved changes.\nLeave the concept anyway?")
        transition.abort()
      else
        @get('saveAllButton').clearSubscribers()
        true
`export default ConceptsShowRoute`
