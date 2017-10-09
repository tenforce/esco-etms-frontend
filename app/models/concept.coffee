`import DS from 'ember-data'`
`import env from '../config/environment'`
`import ESCO from 'ember-esco-concept-description'`

defaultLang = env.etms.defaultLanguage
Concept = DS.Model.extend ESCO.Concept,
  notify: Ember.inject.service('notify')
  # those read only fields will be removed from requests in the serializer
  # we had to do this because some concepts have lots and lots of labels and the whole list was being sent even if we updated one field
  readOnlyAttributes: ['skillType']
  readOnlyRelationships: ['pref-labels', 'alt-labels', 'hidden-labels']
  dirty: false
  code: null
  anyChildren: true
  isDeprecated: false
  disableEditingInSearchResults: false

  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'

  isEditable: DS.attr('string')
  lastModified: DS.attr('string')
  issued: DS.attr('string')
  types: DS.attr('string-set')
  codes: DS.attr('string-set')
  escoNote: DS.attr('string')
  replaces: DS.hasMany('concept', inverse: 'replacements')
  isUnderCreation: DS.attr('boolean')
  hasPublicationStatus: DS.belongsTo('publication-status', inverse: null)
  underRegulation: DS.belongsTo('concept', inverse: null)
  lastModifier: DS.belongsTo('user', inverse: null, async: false )
  bookmarkedBy: DS.hasMany('bookmark', inverse:null)

  nace: DS.hasMany('concept', inverse:null)
  prefLabels: DS.hasMany('concept-label', inverse: null)
  taxonomy: DS.hasMany('concept-scheme', inverse: null)
  taxonomies: Ember.computed.alias 'taxonomy'
  altLabels: DS.hasMany('concept-label', inverse: null)
  hiddenLabels: DS.hasMany('concept-label', inverse: null)

  ## Check first if the concept is editable and then if it is in an editable state.
  disableEditing: true
  disableEditingObserver: Ember.observer 'hasPublicationStatus', 'isEditable', (->
    @get('hasPublicationStatus').then (status) =>
      disableEditing = (not (@get('isEditable') is 'true')) or (not (status and status.get('isEditable')))
      @set('disableEditing', disableEditing)
  ).on('disableEditing')


  disableEditingInSearchResultsObserver: Ember.observer 'hasPublicationStatus', (->
    status = @get 'hasPublicationStatus'
    @get('hasPublicationStatus').then (status) =>
      if (not status) or status.get('isEditable') is true
        @set 'disableEditingInSearchResults', false
      else
        @set 'disableEditingInSearchResults', true
  ).on('hasPublicationStatus')

  isDeprecatedObserver: Ember.observer 'hasPublicationStatus', ( ->
    @get('hasPublicationStatus').then (status) =>
      if status # Broader concepts without status
        label = status.get('label')
        if label and ((label is 'deprecated') or (label is 'ready for deprecation'))
          @set 'isDeprecated', true
        else
          @set 'isDeprecated', false
  ).on('hasPublicationStatus')

  save: () ->
    if not @get('isDeleted')
      @set('lastModifier', @get('user'))
      @set('lastModified', (new Date()).toISOString())
    console.log "TODO: saving editings for a published concept -> put it into 'edited'"
    console.log "TODO: do this for linking too"

    # auto setting of status of saving for properties
    prop = @get('propertiesToSave')
    prop.forEach (elem) =>
      @set("#{elem.propertyName}Saving", true)
      @set("#{elem.propertyName}Saved", false)
      @set("#{elem.propertyName}Failed", false)
      @set(elem.propertyName, elem.newValue)
    prom = @_super(arguments...)
    prom.then (newModel) ->
      prop.forEach (elem) =>
        newModel.set("#{elem.propertyName}Saving", false)
        newModel.set("#{elem.propertyName}Saved", true)
        newModel.set("#{elem.propertyName}Failed", false)
    prom.catch (reason) =>
      failures = []
      prop.forEach (elem) =>
        @set("#{elem.propertyName}Saving", false)
        @set("#{elem.propertyName}Saved", false)
        @set("#{elem.propertyName}Failed", true)
        @set(elem.propertyName, elem.oldValue)
        failures.push(elem.displayName)
      if failures.get('length') > 0
        msg = "An error occurred when saving this concept, the following properties have not been saved : [#{failures.join(', ')}]."
      else
        msg = "An error occurred when saving this concept."
      @get('notify').error(msg)
    prom.finally =>
      @get('propertiesToSave').clear()


  propertiesToSave: Ember.A()
  addPropertyToSave: (propertyName, displayName, newvalue, oldvalue) ->
    @removePropertyToSave(propertyName)
    elem = {propertyName: propertyName, displayName: displayName, newValue: newvalue, oldValue:oldvalue}
    array = @get('propertiesToSave')
    array.pushObject(elem)
    return elem
  removePropertyToSave: (propertyName) ->
    array = @get('propertiesToSave')
    elem = array.findBy('propertyName', propertyName)
    if elem
      array.removeObject(elem)
      return elem
    return undefined


  defaultCode: Ember.computed 'codes', ->
    filtered = @get('codes')?.filter (code) ->
      (code.search 'CTC') is -1
    if Ember.isPresent(filtered)
      filtered[0]
    else
      undefined

  # Recursively infer the group code.
  # It's either the specified code or that of the broader.
  inferredGroupCode: Ember.computed 'defaultCode', ->
    code = @get 'defaultCode'
    if code
      Ember.RSVP.resolve code
    else
      @get('broader').then((broaders) ->
        codes = []
        promises = []
        broaders.forEach (broader) =>
          prom = broader.get('inferredGroupCode')
          promises.push(prom)
          prom.then (broCode) =>
            console.log "broader : "+broader.get('id')
            if broCode?.length > 0 then codes.push(broCode)
        Ember.RSVP.Promise.all(promises).then =>
          if codes.length > 0
            # this is needed, because some broaders already send a joined splittedString
            # so uniq() is not enough in it self in this case:
            # ["SREF.01", "SREF.01", "SREF.01, SREF.06"], because it returns this:
            # ["SREF.01", "SREF.01, SREF.06"]
            #
            # We make one big string, then make it into an array
            # Remove duplicated ones
            # sort it and return as a joined string
            codeString = codes.join(', ')
            splittedString = codeString.split(', ')
            uniqueCodes = splittedString.uniq()
            return uniqueCodes.sort().join(', ')
          else return undefined
      ).catch((reason) ->
        Ember.RSVP.resolve "Could not find the group code for this concept")

  # The relation to either the occupationScheme or the skillScheme
  # if it's skillABCScheme, it should go to the SkillScheme
  conceptSchemeId: Ember.computed 'taxonomy', ->
    @get('taxonomy').then (taxonomy) ->
      test = taxonomy?.filter (t) ->
        t.id is env.etms.occupationScheme or t.id is env.etms.skillScheme or t.id is env.etms.skillABCScheme
      if test.length > 0
        if test[0].id is env.etms.skillABCScheme
          return env.etms.skillScheme
        test[0].id
      else
        null

  # String representing the type of a concept
  # Non-leaf concepts are named after their conceptScheme
  conceptTypeString: Ember.computed 'taxonomy', ->
    if @get('isOccupation')
      Ember.RSVP.resolve "Occupation"
    else
      if @get('isSkillKnowledge')
        Ember.RSVP.resolve "Knowledge"
      else if @get('isSkillSkill')
        Ember.RSVP.resolve "Skill"
      else
        @get('taxonomy').then (taxonomy) ->
          return "Skill concept" if taxonomy?.any (t) ->
            t.id is env.etms.skillScheme
          return "Occupation concept" if taxonomy?.any (t) ->
            t.id is env.etms.occupationScheme


  languagePreference: Ember.computed 'user.language', 'user.showIscoInChosenLanguage', ->
    array = []
    if @get('user.showIscoInChosenLanguage') is 'yes'
      array.push @get('user.language')
    array.push 'en'
    return array

  #languagePreference: ["fr", "en"]

  hasChildren: Ember.computed "anyChildren", ->
    return @get('anyChildren')

  # TODO : We should have a language set in the model, all properties should then try to get values according to that language.
  # TODO : To do so, we should have a function to get the value of a property according to a language.
  preflabel: Ember.computed 'prefLabels', 'languagePreference', ->
    langs = @get 'languagePreference'
    @get('prefLabels').then (labels) ->
      best = null
      langs.map (lang) ->
        best ||= labels.filterBy('language', lang)?[0]?.get('literalForm')
      best || labels.objectAt(0)?.get('literalForm')
  prefdescription: Ember.computed 'description.@each', 'languagePreference', ->
    langs = @get 'languagePreference'
    descriptions = @get('description')
    best = null
    langs.map (lang) =>
      best ||= descriptions.filterBy('language', lang)?[0]?.get('content')
    best || labels.objectAt(0)?.get('content')

  # the language currently displayed on the platform
  language: "en"

  # computed properties do not check with promises, easier to just load the preflabel which we use everywhere anyway
  loadDefaultPrefLabelObjectObserver: Ember.observer('localizedPrefLabelObject', ->
    @get('localizedPrefLabelObject').then (object) =>
      @set('loadedDefaultPrefLabelObject', object)
  ).on('init')
  loadedDefaultPrefLabelObject: undefined
  loadedDefaultPrefLabel: Ember.computed.alias 'loadedDefaultPrefLabelObject.literalForm'


  localizedPrefLabelObject: Ember.computed 'localizedPrefLabels', 'localizedPrefLabels.firstObject', ->
    @get('localizedPrefLabels')?.then (array) ->
      return array?.get('firstObject')
  localizedPrefLabel: Ember.computed 'localizedPrefLabelObject.literalForm', ->
    @get('localizedPrefLabelObject').then (object) ->
      return object?.get('literalForm')

  localizedPrefLabels: Ember.computed 'prefLabels', 'language', ->
    @get('prefLabels')?.then (labels) =>
      res = Ember.ArrayProxy.create content: labels?.filterBy('language', @get('language'))
      return res.sortBy('literalForm')
  localizedAltLabels: Ember.computed 'altLabels', 'language', ->
    @get('altLabels')?.then (labels) =>
      res = Ember.ArrayProxy.create content: labels?.filterBy('language', @get('language'))
      return res.sortBy('literalForm')
  localizedHiddenLabels:Ember.computed 'hiddenLabels', 'language', ->
    @get('hiddenLabels')?.then (labels) =>
      res = Ember.ArrayProxy.create content: labels?.filterBy('language', @get('language'))
      return res.sortBy('literalForm')
`export default Concept`
