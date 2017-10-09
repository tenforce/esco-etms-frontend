`import DS from 'ember-data'`
`import HasManyQuery from 'ember-data-has-many-query'`
`import ESCO from 'ember-esco-concept-description'`

ConceptLabel = DS.Model.extend ESCO.Label,
  prefLabelOf: DS.belongsTo('concept', inverse: null)
  altLabelOf: DS.hasMany('concept', inverse: null)
  hiddenLabelOf: DS.hasMany('concept', inverse: null)
  source: DS.attr('string')

  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  lastModifier: DS.belongsTo('user', async: false, inverse: null)
  lastModified: DS.attr('string')


  hasDirtyRelations: Ember.computed 'hasDirtyRoles', ->
    @get('hasDirtyRoles')

  _savedRolesLoaded: false
  savedRoles: undefined
  initSavedRoles: ->
    arr = []
    @set('_savedRolesLoaded', false)
    @get('roles').then (roles) =>
      roles.forEach (role) ->
        arr.push(role)
      @set('savedRoles', arr)
      @set('_savedRolesLoaded', true)
      return arr
# TODO : refactor this in something less hackish
  hasDirtyRoles: Ember.computed 'roles.length', 'savedRoles.length', '_savedRolesLoaded', ->
    savedRoles = @get('savedRoles')
    unless savedRoles then savedRoles = @initSavedRoles()

    unless @get('_savedRolesLoaded') then return false

    return not @arraysEqual(savedRoles, @get('roles'))

  savedLiteralForm: undefined
  initSavedLiteralForm: ->
    savedLit = {content: @get('literalForm'), language: @get('language')}
    @set('savedLiteralForm', savedLit)
    return savedLit
  hasDirtyLiteralForm: Ember.computed 'literalForm', 'language', 'savedLiteralForm.content', 'savedLiteralForm.language',  ( ->
    savedLit = @get('savedLiteralForm')
    unless savedLit
      savedLit = @initSavedLiteralForm()
    if (@get('literalForm') != savedLit['content']) or (@get('language') != savedLit['language'])
      return true
    else
      return false
  )


  dirty: Ember.computed 'isNew', 'hasDirtyAttributes', 'hasDirtyLiteralForm', 'hasDirtyRelations', ->
# dirty trick but we are only interested in dirty new terms if they have a dirty literal form (so a not empty one)...
    if @get('isNew') then return @get('hasDirtyLiteralForm')
    return @get('hasDirtyAttributes') or @get('hasDirtyLiteralForm') or @get('hasDirtyRelations')

# TODO : See if possible to refactor those in a... nicer way
  reload: () ->
    @rollbackAttributes()
    @set('failedReload', false)
    @_super().then((term) =>
      term.get('roles').reload().then (roles) =>
        unless @get('isDestroyed')
          console.log "model success on reload"
          @set('reloadStatus', "success")
          @set('failedReload', false)
          @set('failedSave', false)
          @initSavedLiteralForm()
          @initSavedRoles()
          #term.set('roles', roles)
          return roles
      return term
    ).catch( (error) =>
      console.log "model failure on reload"
      unless @get('isDestroyed')
        @set('failedReload', true)
      throw error
    )
  save: () ->
    if not @get('isDeleted')
      @set('lastModifier', @get('user'))
      @set('lastModified', (new Date()).toISOString())
      @set('isSaved', false)
      @set('failedSave', false)
      @set('failedReload', false)
      # TODO : clear additional literal forms
      @clearMultipleLiteralForms()
    @_super(arguments...).then((model) =>
      unless @get('isDestroyed')
        console.log "model success on save"
        @set('isSaved', true)
        @set('failedSave', false)
        @initSavedLiteralForm()
        @initSavedRoles()
      return model
    ).catch( (error) =>
      console.log "model failure on save"
      unless @get('isDestroyed')
        @set('isSaved', false)
        @set('failedSave', true)
      throw error
    )
  clearMultipleLiteralForms: ->
    @get('literalFormValues')?.splice(1)


  arraysEqual: (a, b) ->
    if a == b
      return true
    if a == null or b == null
      return false
    if a.get('length') != b.get('length')
      return false

    i = 0
    while i < a.get('length')
      unless b.contains(a.objectAt([i]))
        return false
      ++i
    true

# TODO : put those in ember-esco-concept-description
  hasRole: (role) ->
    @get('roles').then (roles) ->
      return roles.contains(role)
# modifiers
  setRole: (role, isActive) ->
    new Ember.RSVP.Promise (resolve, reject) =>
      success =   =>
        if isActive
          @get('roles').pushObject(role)
        else
          @get('roles').removeObject(role)
        resolve()
      failure = (err) ->
        reject(err)
      @get('roles').then(success,failure)
  toggleRole: (role) ->
    new Ember.RSVP.Promise (resolve, reject) =>
      success =   =>
        if @get('roles').contains(role)
          @get('roles').removeObject(role)
        else
          @get('roles').addObject(role)
        resolve()
      failure = (err) ->
        reject(err)
      @get('roles').then(success,failure)

`export default ConceptLabel`

