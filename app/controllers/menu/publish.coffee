`import Ember from 'ember'`
`import UserRights from '../../mixins/user-rights'`
`import ENV from '../../config/environment'`


PublishController = Ember.Controller.extend UserRights,
  hierarchyService: Ember.inject.service()
  userUuid: Ember.computed.oneWay 'user.id'
  loading: false
  store: Ember.inject.service()
  conceptSchemes: Ember.computed.oneWay 'model'
  hrefUrl: Ember.computed 'userUuid', 'publicationName', 'conceptScheme', ->
    userUuid = @get 'userUuid'
    # TODO : temporary solution for now, file still get sent back for Firefox with quotes around it though
    publicationName = @get('publicationName')
    conceptScheme = @get 'conceptScheme'
    ENV.baseURL + "/publisher/publish?uuid=#{userUuid}&publication=#{publicationName}&conceptscheme=#{conceptScheme}"
  conceptScheme: '6b73f82c-2543-4a72-a86d-e988869df5ca'

  actions:
    schemeChanged: (scheme) ->
      @set 'conceptScheme', scheme

    publishCall: ->

      go = window.confirm "Taxonomy Publication Service Warning:\n\nYou requested to start a publication action..\nAs the process is irreversible it is recommended to run all validations before going ahead with the publication.\n\nClick OK if you want to continue or Cancel to take you to the validations page."
      if go is true
        ###
        # The publisher microservice will change the state of concepts without passing
        # through the cache, so it is needed to reset it manually so concepts will reflect
        # the new changes.
        ###
        if @get('publicationName') is undefined or @get('publicationName') == ''
          @set('publicationMessage', 'Publication name cannot be empty')
        else
          @set('publicationMessage', 'Download will start soon. This may take some time, go grab a coffee...')

          # Clear the hierarchy cache in hierarchyService (frontend part)
          @get('hierarchyService')._clearCache()

          promises = []

          # Clear mu-cl-resources cache.
          promises.push(
            @get('store').createRecord('clear-cache-request', {}).save())

          # Clear mu-resources cache.
          promises.push(
            new Ember.RSVP.Promise (resolve, reject) ->
              Ember.$.ajax
                url: '/cache/clear'
                type: 'POST'
                contentType: 'application/vnd.api+json'
                success: (result) ->
                  resolve()
                error: (err) ->
                  reject(err))

          # Clear the hierarchy cache (backend)
          promises.push(
            new Ember.RSVP.Promise (resolve, reject) ->
              Ember.$.ajax
                url: '/hierarchy/cache/clear'
                type: 'POST'
                contentType: 'application/vnd.api+json'
                success: (result) ->
                  resolve()
                error: (err) ->
                  reject(err))


          Ember.RSVP.Promise.all(promises)
            .then (results) =>
              @set('publicationMessage', 'Download started.')
              console.log "Download started."
              window.location.href = @get 'hrefUrl'

            .catch (reason) =>
              @set('publicationMessage', 'Download failed.')
              console.log "Download failed.", reason
      else
        @transitionToRoute 'menu.validation'


`export default PublishController`
