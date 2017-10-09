`import Ember from 'ember'`
`import clearHierarchyCache from '../utils/clear-hierarchy-cache'`
`import statusTransitions from '../utils/status-transitions'`

WrapperConceptStatusSelectorComponent = Ember.Component.extend
  store: Ember.inject.service()
  saveAllButton: Ember.inject.service()

  ## If object.issued is undefined it implies the concept has not yet been published
  description: Ember.computed 'object.issued', 'selectedStatus', ->
    {
      nodes: ['draft', 'ready for publication', 'published', 'edited', 'ready to be deprecated', 'deprecated'],
      edges: [
        {
          from: 'draft',
          to: 'ready for publication',
          predicates: [
            (() => @get('object.issued') is undefined )
          ],
          predicateCriteria: 'all'
        },
        {
          from: 'ready for publication',
          to: 'draft',
          predicates: [
            (() => @get('object.issued') is undefined )
          ],
          predicateCriteria: 'all'
        },
        {
          from: 'ready for publication',
          to: 'edited',
          predicates: [
            (() => @get('object.issued') isnt undefined )
          ],
          predicateCriteria: 'all'
        },
        {
          from: 'published',
          to: 'edited',
          predicates: [
            (() => @get('object.issued') isnt undefined)
          ],
          predicateCriteria: 'all'
        },
        {
          from: 'edited',
          to: 'ready for publication',
          predicates: [
            (() => @get('object.issued') isnt undefined)
          ],
          predicateCriteria: 'all'
        }
      ]
    }

  availableStatuses: Ember.computed 'description', 'selectedStatus', ->
    description = @get 'description'
    selectedStatus = @get 'selectedStatus'
    statusTransitions(description, selectedStatus.get('label'))

  statusLabels: Ember.computed 'availableStatuses', ->
    @get('availableStatuses').then (availableStatuses) =>
      @get('store').query('publicationStatus', {}).then (statuses) =>
        statuses.filter (status) =>
          availableStatuses.includes(status.get('label')) and status.get('isSelectable')

  selectedStatus: Ember.computed.alias 'object.hasPublicationStatus'

  statusForCss: Ember.computed 'selectedStatus', ->
    status = @get('selectedStatus.label')
    if status
      'status-selector ' + status.replace(`/ /g,'-'`)
    else
      'status-selector '

  isEditable: Ember.computed 'object.disableEditing', ->
    !@get('object.disableEditing')

  isDeprecated: Ember.computed 'object.hasPublicationStatus', ->
    status = @get 'object.hasPublicationStatus'
    if status.get('label') == 'deprecated' or status.get('label') == 'ready for deprecation'
      return true
    return false

  isDeleted: Ember.computed 'object.hasPublicationStatus', ->
    status = @get 'object.hasPublicationStatus'
    if status.get('label') == 'deleted'
      return true
    return false

  actions:
    selectStatus: (item) ->
      if @get('saveAllButton.dirty') and !confirm("If you switch status you will lose all unsaved changes.\nSwitch anyway?")
      else
        @get('saveAllButton').resetAll()
        @set 'selectedStatus', item
        @get('object').save().then =>
          clearHierarchyCache()

`export default WrapperConceptStatusSelectorComponent`
