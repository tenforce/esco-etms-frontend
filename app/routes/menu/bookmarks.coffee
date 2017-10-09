`import Ember from 'ember'`
`import UserRights from '../../mixins/user-rights'`
`import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin'`
`import EnsureLanguageSetMixin from '../../mixins/ensure-language-set'`

BookmarksRoute = Ember.Route.extend AuthenticatedRouteMixin, EnsureLanguageSetMixin, UserRights

`export default BookmarksRoute`
