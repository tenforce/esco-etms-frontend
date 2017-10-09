`import Ember from 'ember'`

AdminImportController = Ember.Controller.extend


# DEPRECATED
  parseResponse: (response) ->
    @set 'success', true
  parseError: (response) ->
    @set 'error', true
  createFormData: () ->
    data = new FormData()
    data.append "file", @get('file')
    data.append "incremental", @get('isIncremental')
    data
  actions:
    setFile: (ev) ->
      return unless Ember.isArray ev.target.files
      @set 'file', ev.target.files[0]
    submitFile: ->
      @set 'success', false
      @set 'loading', true
      @set 'error', false
      Ember.$.ajax
        url: '/upload',
        type: 'POST',
        headers:
          'Accept': 'application/json'
        data: @createFormData()
        cache: false,
        enctype: 'multipart/form-data',
        processData: false,
        success: (response, status, xhr) => @parseResponse(response)
        error:  (xhr, status, response) => @parseError(response)
        complete: =>
          @set 'loading', false

`export default AdminImportController`
