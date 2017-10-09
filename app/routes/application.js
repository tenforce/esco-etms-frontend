/**
 NOTE: this is a JS file to work with ember-simple-auth, see https://github.com/simplabs/ember-simple-auth/issues/851
 DO NOT CONVERT TO COFFEESCRIPT
**/

import Ember from 'ember';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin, {
  intl: Ember.inject.service(),
  beforeModel() {
    this.heartbeat();
    return this.get('intl').setLocale('en-gb');
  },

  store: Ember.inject.service(),

  heartbeat() {
    var self = this;
    Ember.run.later((function() {
      var refreshPage = function(data, textStatus, xhr) {
        var statuscode = xhr.status;

        if (statuscode !== 200){
          location.reload();
        }
      };

      Ember.$.ajax({
        url: "/kpis/version",
        dataType: 'json',
        success: refreshPage,
        error: refreshPage
      });

      self.heartbeat();
    }), 1000 * 60);
  },
  currentUser: Ember.inject.service(),
  sessionInvalidated() {
    this.get('currentUser').sessionInvalidated();
  },
  sessionAuthenticated() {
    this.get('currentUser').sessionAuthenticated();
    var previous = this.get('session.attemptedTransition');
    if (previous) {
      Ember.run.later(function() {
        previous.retry();
      }, 500);
    }
    var res = this._super(arguments);

    return res;
  }
});
