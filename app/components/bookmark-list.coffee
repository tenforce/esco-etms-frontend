`import Ember from 'ember'`

BookmarkListComponent = Ember.Component.extend
  store: Ember.inject.service('store')
  currentUser: Ember.inject.service()
  user: Ember.computed.alias 'currentUser.user'

  bookmarks: Ember.computed.alias 'user.bookmarks'


  emptyBookmarks: Ember.computed 'bookmarks', ->
    @get('bookmarks').then (bookmarks) ->
      not bookmarks?.get('length') > 0

  actions:
    delete: (b) ->
      b.destroyRecord()

`export default BookmarkListComponent`
