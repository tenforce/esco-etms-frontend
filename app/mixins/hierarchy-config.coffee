`import Ember from 'ember'`
`import {sortByPromise} from 'ember-esco-plugins'`
`import env from '../config/environment'`

HierarchyConfigMixin = Ember.Mixin.create
  statuses: env.statuses
  disableTaxonomyChange: env.etms.disableTaxonomyChange
  selectTaxonomyTitle: env.etms.tooltipTaxonomyChange
  displayLanguage: "en"
  status: 'all'

  ###
  # Builds a filter object that is compatible with the taxonomy-browser's filter requirements
  ###
  filters: Ember.computed ->
    filterConfig = env.filters
    config = filterConfig.inStatus
    @_computeFilters(config)

  # based on the given config, compute the right filter spec
  _computeFilters: (config) ->
    statuses = @get 'statuses'
    self = this
    filters = statuses.map (status) ->
      currentConfig = config
      # all is a special one, we need a different filter for it or none if also not filtering
      if status.id == 'all'
        currentConfig = {}
      filter =
        name: status.name
        id: currentConfig.id
        params: {}
      currentConfig.variables?.map (name) ->
        filter.params[name] = self.get name
      filter.params.status = status.id
      filter

  # NOTE : this object will be passed as a parameter to the taxonomy browser, which will then merge it with its default config, which means
  # all parameters specified here will override the default ones
  config: Ember.computed 'defaultExpanded', 'displayLanguage', ->
    # if display language changes, fetch the concepts again
    @get 'displayLanguage'
    # property path to the property that should be used as label
    # e.g. model.label.en would be label.en
    Ember.Object.create
      labelPropertyPath: 'loadedDefaultPrefLabel'
      onActivate: (node) =>
        @send 'activateItem', node
      # max amount (n) of children to be shown before a load more button is presented
      # load more button shows an extra n children
      showMaxChildren: 50
      noScroll: true
      included: ['pref-labels.pref-label-of','has-publication-status']
      # route used in link-to of the node
      linkToRoute: 'concepts.show'
      afterComponent: 'concept-status'
      beforeComponent: 'concept-notation'

`export default HierarchyConfigMixin`
