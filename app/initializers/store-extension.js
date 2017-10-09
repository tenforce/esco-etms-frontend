import DS from 'ember-data';

export function initialize(/* application */) {
  DS.Store.reopen({
    findOneQuery: function(type, id, query) {
      var store = this;
      // var typeClass = store.modelFor(type);
      var adapter = store.adapterFor(type);
      // var serializer = store.serializerFor(type); // we don't need this with JSONAPI
      var url = adapter.buildURL(type, id);
      var ajaxPromise = adapter.ajax(url, 'GET', { data: query });

      return ajaxPromise.then(function(rawPayload) {
        store.pushPayload( rawPayload );
        return store.findRecord( type , id );
      });
    }
  });
}

export default {
  name: 'store-extension',
  initialize
};
