`import Ember from 'ember'`
`import env from '../config/environment'`

WrapperNaceComponent = Ember.Component.extend
  tagName: ''
  conceptScheme: Ember.computed ->
    env.etms.naceScheme

`export default WrapperNaceComponent`
