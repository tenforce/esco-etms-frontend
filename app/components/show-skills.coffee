`import Ember from 'ember'`
`import env from '../config/environment'`

ShowSkillsComponent = Ember.Component.extend
  hierarchyCache: Ember.inject.service()
  store: Ember.inject.service('store')
  fullDetail: false
  classNames: ""
  showSkills: true
  showAddSkills: Ember.computed.not 'concept.disableEditing'


  searchFilter: Ember.computed ->
    typeString = switch @get('skillType')
      when env.relationshipTypes.KNOWLEDGE_IRI then "knowledge"
      when env.relationshipTypes.SKILL_IRI then "skill"
    include: ["skillType:*" + typeString]

  popupButtonId: Ember.computed ->
    @get('skillRelation')

  skillUri: Ember.computed 'skillRelation', ->
    if @get 'skillRelation'
      if @get('skillRelation').indexOf('essential') >= 0
        return env.relationshipTypes.ESSENTIAL_SKILL_IRI
      return env.relationshipTypes.OPTIONAL_SKILL_IRI
    return ""

  skills: Ember.computed 'concept', 'skillRelation', ->
    @get('concept.relations').then (relations) =>
      relations.reload().then (reloaded) =>
        @get("concept.#{@get('skillRelation')}")

  skillsToDisplay: Ember.computed 'skills', 'skillLimit', 'shadowSkills', 'sortedSkills', ->
    @computeElementView()

  shadowSkills: Ember.computed 'fullDetail','skillLimit', 'skills', 'skills.length', ->
    if @get('fullDetail') then return false

    limit = @get('skillLimit')
    @get('skills').then (result) ->
      if not limit or (Ember.get(result, 'length')) <= limit
        return false
      else
        return true

  sortedSkills: Ember.computed 'skills', ->
    @get('skills').then (skills) =>
      promises = []
      skills.map (skill) ->
        promises.push(skill)
      Ember.RSVP.all(promises).then (resolvedSkills)=>
        @sortByPromise(resolvedSkills, 'defaultPrefLabel')


  toggleTooltip: "Click to show the full list"

  typeWatcher: Ember.inject.service('concept-type-watcher')
  occupationsOrigin: Ember.computed.alias 'typeWatcher.occupationsOrigin'
  skillsOrigin: Ember.computed.alias 'typeWatcher.skillsOrigin'
  selectedOrigin: Ember.computed.alias 'typeWatcher.selectedOrigin'

  sortByPromise: (list, path) ->
    unless Ember.isArray(path)
      path = [path]

    promises = list.map (item) ->
      hash = {}
      path.map (key) ->
        hash[key] = new Ember.RSVP.Promise (resolve) -> resolve(Ember.get(item, key))
      Ember.RSVP.hash hash
    Ember.RSVP.all(promises).then (resolutions) ->
      toSort = resolutions.map (solutions, index) ->
        result = { _sorterItem: list.objectAt(index) }
        for key, solution of solutions
          result[key] = solution
        result
      sorted = toSort.sortBy.apply toSort, path
      sorted.map (item) ->
        item._sorterItem


  addElements: (items) ->
    typeuri = @get 'skillUri'
    if typeuri
      @get('skillsToDisplay').then (skills) =>
        items.forEach (item) =>
          newRelation = @get('store').createRecord('conceptRelation',{
            type: [typeuri],
            from: @get('concept'),
            to: item
            })
          newRelation.save().then =>
            skills.pushObject(item)
            @updateElementView()
    else
      console.log 'error: no skilluri'

  deleteElement: (relation) ->
    concept = @get('concept')
    relations = concept.get('relations')
    relations.then (relationIt) =>
      relationIt.forEach (item, i) =>
        if((Ember.get(item, 'from.id') == Ember.get(relation, 'id')) or Ember.get(item, 'to.id') == Ember.get(relation, 'id'))
          item.destroyRecord()
          @get('skillsToDisplay').then (skills) =>
            skills.removeObject(relation)
            @updateElementView()

  computeElementView: ->
    limit = @get('skillLimit')
    Ember.RSVP.hash(
      shadow: @get('shadowSkills')
      skills: @get('sortedSkills')
    ).then (hash) =>
      @set 'showSkills', not Ember.isEmpty hash.skills
      if hash.shadow
        @set('skillNumber', limit)
        return hash.skills.slice(0, limit)
      else
        @set('skillNumber', hash.skills.length)
        return hash.skills


  updateElementView: ->
    @set 'skillsToDisplay', @computeElementView()


  actions:
    deleteRelation: (item) ->
      @deleteElement(item)
      false

    saveAllElements: (results) ->
      @addElements(results)
      false

    toggleDetail: ->
      @toggleProperty 'fullDetail'

    handleSkillClick: (skill) ->
      ###if skill.get('isOccupation')
      @set('selectedOrigin', @get('occupationsOrigin'))###
      @set 'hierarchyCache.hasPath', false
      @sendAction 'skillClick', skill

    transitionToCreate: ->
      @sendAction('transitionToCreate', @get('skillRelation'))

`export default ShowSkillsComponent`
