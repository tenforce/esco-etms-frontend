`import Ember from 'ember'`

PopupComponentComponent = Ember.Component.extend
  classNames: ['action']
  # TODO this component is too specialized. It does too many things just to pass stuff to the create and search tabs.
  # Either generalize properly and make an instance, or don't act like it's general at all (see usage of {{component}} in hbs).

  displayPopup: false

  # UUID of the concept scheme to work in
  conceptScheme: Ember.K

  ## Search defaults
  # Enable checkboxes to select multiple elements at once from a single search
  allowMultiSelect: true

  # used for server side filtering
  searchFilter: {
    # Array of strings of the form ["field:value", "field:value"]
    include: [] # Only include results matching all these filters
    exclude: [] # Exclude results matching any of these filters
  }

  # this is to allow parent components to change the classes and the text of the add button
  buttonText: "+"
  buttonClasses: 'btn btn--small btn--add'

  handleCreateClicked: ->
    @sendAction('transitionToCreate')

  actions:
    saveAllElements: (results) ->
      @sendAction('saveAllElements', results)
      @toggleProperty 'displayPopup'

    cancelCreate: ->
      @toggleProperty 'displayPopup'
      @set 'selectedTab', @get('tabs')["link"]

    togglePopup: ->
      @toggleProperty 'displayPopup'
      if @get('displayPopup') then $('html, body').animate { scrollTop: $('#' + @elementId).offset().top }, 2000

    selectTab: (tab) ->
      @set 'selectedTab', tab

    createClicked: ->
      @handleCreateClicked()


`export default PopupComponentComponent`
