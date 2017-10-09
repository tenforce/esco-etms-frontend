import Adaptive from 'ember-simple-auth/session-stores/adaptive';
export default Adaptive.extend({
  cookieName: 'ember_simple_auth_etms:session',
  localStorageKey: 'ember_simple_auth_etms:session'
});