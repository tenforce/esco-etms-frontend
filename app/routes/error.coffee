`import Ember from 'ember'`
`import eraseCookie from '../utils/clear-cookie'`

ErrorRoute = Ember.Route.extend
  activate: ->
    # often just a problem with us not being authenticated
    eraseCookie('ecas')
    eraseCookie('JSESSIONID')
    eraseCookie('proxy_session')
    eraseCookie('mu_session')
    eraseCookie('ecas_login')


`export default ErrorRoute`
