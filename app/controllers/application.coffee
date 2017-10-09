`import Ember from 'ember'`

ApplicationController = Ember.Controller.extend
  activateItem: (item) ->
    if item.get('isSkill') then id = @get('conf.settings.skillScheme')
    else if item.get('isOccupation') then id = @get('conf.settings.occupationScheme')

    if id then @transitionToRoute('concepts.show', id, item.get('id'))
    else
      item.get('taxonomies')?.then (taxonomies) =>
        id = taxonomies.get('firstObject.id')
        if id then @transitionToRoute('concepts.show', id, item.get('id'))
        else
          console.log "could not find information about concept's taxonomy, defaulting to Occupations"
          @transitionToRoute('concepts.show', @get('conf.settings.occupationScheme'), item.get('id'))
  actions:
    activateItem: (item) ->
      @activateItem(item)

`export default ApplicationController`
