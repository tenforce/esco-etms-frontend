`import Ember from 'ember'`

ConceptBookmarkComponent = Ember.Component.extend
  store: Ember.inject.service()
  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'
  conceptId: Ember.computed.alias 'object.id'

  isBookmarked: Ember.computed 'user.bookmarks.[]', 'conceptId', ->
    conceptId = @get('conceptId')
    @get('user.bookmarks').then (bookmarks) =>
      bookmarkConcepts = bookmarks.mapBy('bookmarkConcept')
      Ember.RSVP.all(bookmarkConcepts).then (bookmarkConcepts) =>
        ids = bookmarkConcepts.mapBy('id')
        Ember.RSVP.all(ids).then (ids) =>
          ids.any (id) =>
            id is conceptId

  actions:
    addBookmark: ->
      concept = @get('object')
      now = new Date(Date.now())
      bookmark = @get('store').createRecord('bookmark', {
        bookmarkDate: now,
        bookmarkConcept: concept
      })
      bookmark.save().then (newB) =>
        @get('user.bookmarks').then (bookmarks) =>
          bookmarks.pushObject(newB)
          @get('user').save()

    removeBookmark: ->
      concept = @get('object')
      store = @get('store')
      @get('user.bookmarks').then (bookmarks) =>
        bookmark = bookmarks.find (b) =>
          b.get('bookmarkConcept.id') is concept.id
        bookmark.destroyRecord()
        @get('user').save()

`export default ConceptBookmarkComponent`
