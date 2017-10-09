`import Ember from 'ember'`

WrapperTermsManagerComponent = Ember.Component.extend
  tagName: ''
  showOnlyPreferred: false

  store: Ember.inject.service()
  notify: Ember.inject.service('notify')

  model: Ember.computed.alias 'object'

  # whether terms should display their save button
  displayActions: true

  emptyPrefTerms: Ember.computed 'prefTerms.length', ->
    return @get('prefTerms.length') is 0

  removeRoleFromTerms: (role) ->
    if role is @get('rolesSet.standardMale')
      sg = role
      g = @get('rolesSet.male')
    else if role is @get('rolesSet.standardFemale')
      sg = role
      g = @get('rolesSet.female')
    else return new Ember.RSVP.Promise =>
      return null

    promises = []
    @get('allTerms').forEach (term) ->
      promises.push(
        term.hasRole(sg).then (bool) ->
          if bool
            arr = []
            arr.push(term.setRole(sg, false))
            if term.get('prefLabelOf')
              arr.push(term.setRole(g, false))
            return Ember.RSVP.Promise.all(arr)
      )
    Ember.RSVP.Promise.all(promises)

  placeholder: "e.g., \"actress//sf\""

  loadingRoleSet: true
  rolesSet: {}

  loading: true
  loadingTerms: true
  prefTerms: []
  altTerms: []
  hiddenTerms: []
  allTerms: Ember.computed 'prefTerms.@each', 'altTerms.@each', 'hiddenTerms.@each', ->
    arr = [@get('newPrefTerm'), @get('newAltTerm'), @get('newHiddenTerm')]
    return arr.concat(@get('prefTerms'), @get('altTerms'), @get('hiddenTerms'))

  targetLanguage: "en"
  modelOrLanguageChangeChecker: Ember.observer('model.id', 'targetLanguage', ->
# If those properties are not set, no point in going further
    #unless @get('model.id') and @get('targetLanguage') then return

    @set('loading', true)
    promises = []

    console.log "Loading label-roles"
    @set('loadingRoleSet', true)
    promises.push @get('store').findAll('label-role').then (roles) =>
      roles.forEach (role) =>
        switch role.get('preflabel')
          when "standard male term"
            @set('rolesSet.standardMale', role)
            role.set('sortOrder', 1)
            role.set('displayLabel', "ST. MALE")
          when "standard female term"
            @set('rolesSet.standardFemale', role)
            role.set('sortOrder', 2)
            role.set('displayLabel', "ST. FEMALE")
          when "male"
            @set('rolesSet.male', role)
            role.set('sortOrder', 3)
            role.set('displayLabel', "MALE")
          when "female"
            @set('rolesSet.female', role)
            role.set('sortOrder', 4)
            role.set('displayLabel', "FEMALE")
          when "neutral"
            @set('rolesSet.neutral', role)
            role.set('sortOrder', 5)
            role.set('displayLabel', "NEUTRAL")
      @set('roles', roles.sortBy('sortOrder'))
      @set('loadingRoleSet', false)
      console.log "--- done getting roles ---"

    console.log "Loading terms for [#{@get('model.id')}] in (#{@get('targetLanguage')})"
    @set('loadingTerms', true)
    prom = []
    prom.push @get('model.prefLabels').reload()
    prom.push @get('model.altLabels').reload()
    prom.push @get('model.hiddenLabels').reload()
    promises.push Ember.RSVP.Promise.all(prom).then =>
      Ember.RSVP.hash(
        pref: @get('model.localizedPrefLabels')
        alt: @get('model.localizedAltLabels')
        hidden: @get('model.localizedHiddenLabels')
      ).then (hash) =>
        pref = hash['pref']
        alt = hash['alt']
        hidden = hash['hidden']
        loadingRoles = []
        pref.concat(alt, hidden).forEach (term) ->
          loadingRoles.push(term.get('roles').reload())
        Ember.RSVP.Promise.all(loadingRoles).then =>
          @set('prefTerms', pref)
          @set('altTerms', alt)
          @set('hiddenTerms', hidden)
          @set('loadingTerms', false)
          console.log "--- done loading terms ---"

    Ember.RSVP.Promise.all(promises).then =>
      console.log "Preparing new terms for [#{@get('model.id')}] in (#{@get('targetLanguage')})"
      @generateNewPrefTerm()
      @generateNewAltTerm()
      @generateNewHiddenTerm()
      @set('loading', false)
      console.log "--- done preparing new terms ---"
  ).on('init')
  generateTerm: () ->
    @get('store').createRecord('conceptLabel', literalFormValues: [{content: "", language: @get('targetLanguage')}])
# function to create terms
  generateNewPrefTerm: () ->
    @set('newPrefTerm', @createPrefTerm())
  createPrefTerm: () ->
    term = @generateTerm()
    term.set('prefLabelOf', @get('model'))
    if @get('object.isOccupation')
      term.setRole(@get('rolesSet.neutral'), true)
    term
  generateNewAltTerm: () ->
    @set('newAltTerm', @createAltTerm())
  createAltTerm: () ->
    term = @generateTerm()
    term.set('altLabelOf', [@get('model')])
    term
  generateNewHiddenTerm: () ->
    @set('newHiddenTerm', @createHiddenTerm())
  createHiddenTerm: () ->
    term = @generateTerm()
    term.set('hiddenLabelOf', [@get('model')])
    term
# terms that will be passed as parameters
  newPrefTerm: undefined
  newAltTerm: undefined
  newHiddenTerm: undefined

  deleteTerm: (term, name, index) ->
    term.deleteRecord()
  rollbackTerm: (term, name, index) ->
    console.log "Handle reset of term"
    if term.get('id') then term.reload().then( (reloadedterm) =>
      reloadedterm.get('roles').then (roles) =>
        reloadedterm.set('roles', roles)
    ).catch (error) =>
      @get('notify').error('An error occurred when trying to reload this term')
    else
      term.set('literalForm', '')
      term.set('roles', [])
      term.set('source', undefined)
  saveTerm: (list, addToList, term, name, index) ->
    if term.get('literalForm.length') is 0 and term.get('isDeleted') is false
      console.log "can not save empty term"
      @get('notify').warning({html:"<span>You can not save an empty term.</span><br/><span>If you want to delete it, please use the [-] button located on the right side of the term.</span>"})
      return
    console.log "Handle saving of term"
    term.save().then( (savedTerm) =>
      unless @get('isDestroyed')
        console.log "success on save"
        if savedTerm.get('isDeleted')
          list.removeObject(term)
        else
          if addToList
            list.addObject(term)
    ).catch (error) =>
      throw error

  actions:
    rollbackTerm: (term, name, index) ->
      @rollbackTerm(term, name, index)
    deleteTerm: (term, name, index) ->
      console.log "deleted term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      @deleteTerm(term, name, index)
    savePrefTerm: (term, name, index) ->
      console.log "Saved pref term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      prom = @saveTerm(@get('prefTerms'), false, term, name, index)
      prom?.catch (reason) => @get('notify').error('An error occurred when trying to save this preferred term')
    saveNewPrefTerm: (term, name, index) ->
      console.log "Saved new pref term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      prom = @saveTerm(@get('prefTerms'), true, term, name, index)
      prom?.then () => @generateNewPrefTerm()
      prom?.catch (reason) => @get('notify').error('An error occurred when trying to save this new preferred term')
    saveAltTerm: (term, name, index) ->
      console.log "Saved alt term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      prom = @saveTerm(@get('altTerms'), false, term, name, index)
      prom?.catch (reason) => @get('notify').error('An error occurred when trying to save this non-preferred term')
    saveNewAltTerm: (term, name, index) ->
      prom = @saveTerm(@get('altTerms'), true, term, name, index)
      prom?.then () => @generateNewAltTerm()
      prom?.catch (reason ) => @get('notify').error('An error occurred when trying to save this new non-preferred term')
    saveHiddenTerm: (term, name, index) ->
      console.log "Saved hidden term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      prom = @saveTerm(@get('hiddenTerms'), false, term, name, index)
      prom?.catch (reason) => @get('notify').error('An error occurred when trying to save this hidden term')
    saveNewHiddenTerm: (term, name, index) ->
      console.log "Saved new hidden term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      prom = @saveTerm(@get('hiddenTerms'), true, term, name, index)
      prom?.then () => @generateNewHiddenTerm()
      prom?.catch (reason ) => @get('notify').error('An error occurred when trying to save this new hidden term')

    # pref terms have to be neutral, can have sf/sm and if they have a standard, they should have non-standard too
    togglePrefGender: (term, role, name, index) ->
      # skills terms should not have genders
      if @get('object.isSkill')
        term?.set('roles', [])
        return false
      console.log "Changing #{role.get('preflabel')} on pref term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      # TODO : document
      if role is @get('rolesSet.neutral')
        term.hasRole(role).then (bool) =>
          if bool then @get('notify').warning('You can not remove the "neutral" gender for preferred terms.')
          else term.setRole(@get('rolesSet.neutral'), true)
          return false
      else term.setRole(@get('rolesSet.neutral'), true)

      if role is @get('rolesSet.standardMale')
        term.hasRole(role).then (bool) =>
          if bool
            term.setRole(@get('rolesSet.standardMale'), false)
            term.setRole(@get('rolesSet.male'), false)
          else
            @removeRoleFromTerms(role).then =>
              term.setRole(@get('rolesSet.standardMale'), true)
              term.setRole(@get('rolesSet.male'), true)
        return false

      if role is @get('rolesSet.standardFemale')
        term.hasRole(role).then (bool) =>
          if bool
            term.setRole(@get('rolesSet.standardFemale'), false)
            term.setRole(@get('rolesSet.female'), false)
          else
            @removeRoleFromTerms(role).then =>
              term.setRole(@get('rolesSet.standardFemale'), true)
              term.setRole(@get('rolesSet.female'), true)
        return false

      if role is @get('rolesSet.male')
        Ember.RSVP.hash({g: term.hasRole(@get('rolesSet.male')), sg: term.hasRole(@get('rolesSet.standardMale'))}).then (hash) =>
          if hash['g'] is false
            if hash['sg'] is true then term.setRole(@get('rolesSet.male'), true)
            else
              @get('notify').warning('You can only set the "male" gender for preferred terms if they have the "standard male" gender.')
          if hash['g'] is true
            if hash['sg'] is false then term.setRole(@get('rolesSet.male'), false)
            else
              @get('notify').warning('You can only remove the "male" gender for preferred terms if they do not have the "standard male" gender.')
        return false

      if role is @get('rolesSet.female')
        Ember.RSVP.hash({g: term.hasRole(@get('rolesSet.female')), sg: term.hasRole(@get('rolesSet.standardFemale'))}).then (hash) =>
          if hash['g'] is false
            if hash['sg'] is true then term.setRole(@get('rolesSet.female'), true)
            else @get('notify').warning('You can only set the "female" gender for preferred terms if they have the "standard female" gender.')
          if hash['g'] is true
            if hash['sg'] is false then term.setRole(@get('rolesSet.female'), false)
            else @get('notify').warning('You can only remove the "female" gender for preferred terms if they do not have the "standard female" gender.')
        return false

    # alt terms can have all genders but if it has a standard one, it should also have the non standard version of it
    toggleAltGender: (term, role, name, index) ->
      # skills terms should not have genders
      if @get('object.isSkill')
        term?.set('roles', [])
        return false
      console.log "Changing #{role.get('preflabel')} on alt term [#{term.get('id')}] (index : #{index}) with name : #{name}"

      if role is @get('rolesSet.standardMale')
        term.hasRole(role).then (bool) =>
          if bool
            term.setRole(@get('rolesSet.standardMale'), false)
            # we don't want to toggle off not standard gender
            #term.setRole(@get('rolesSet.male'), false)
          else
            @removeRoleFromTerms(role).then =>
            # if standard, should also be non-standard
              term.setRole(@get('rolesSet.standardMale'), true)
              term.setRole(@get('rolesSet.male'), true)
        return false

      if role is @get('rolesSet.standardFemale')
        term.hasRole(role).then (bool) =>
          if bool
            term.setRole(@get('rolesSet.standardFemale'), false)
            # we don't want to toggle off not standard gender
            #term.setRole(@get('rolesSet.female'), false)
          else
            @removeRoleFromTerms(role).then =>
              # if standard, should also be non-standard
              term.setRole(@get('rolesSet.standardFemale'), true)
              term.setRole(@get('rolesSet.female'), true)
        return false

      if role is @get('rolesSet.male')
        Ember.RSVP.hash({g: term.hasRole(@get('rolesSet.male')), sg: term.hasRole(@get('rolesSet.standardMale'))}).then (hash) =>
          # if the standard is specified, we can not toggle off the non-standard gender
          if hash['sg'] is true then @get('notify').warning('You can only remove the "male" gender for non-preferred terms if they do not have the "standard male" gender.')
          else term.toggleRole(role)
        return false

      if role is @get('rolesSet.female')
        Ember.RSVP.hash({g: term.hasRole(@get('rolesSet.female')), sg: term.hasRole(@get('rolesSet.standardFemale'))}).then (hash) =>
          # if the standard is specified, we can not toggle off the non-standard gender
          if hash['sg'] is true then @get('notify').warning('You can only remove the "female" gender for non-preferred terms if they do not have the "standard female" gender.')
          else term.toggleRole(role)
        return false

      term.toggleRole(role)

# hidden terms can not have genders so we only allow to untoggle them
    toggleHiddenGender: (term, role, name, index) ->
      console.log "Changing #{role.get('preflabel')} on hidden term [#{term.get('id')}] (index : #{index}) with name : #{name}"
      # NB : use toggleRole if hidden labels should be able to have a gender set through the platform
      term.setRole(role, false)
`export default WrapperTermsManagerComponent`
