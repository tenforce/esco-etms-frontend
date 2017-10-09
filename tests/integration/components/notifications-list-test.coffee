`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'notifications-list', 'Integration | Component | notifications list', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{notifications-list}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#notifications-list}}
      template block text
    {{/notifications-list}}
  """

  assert.equal @$().text().trim(), 'template block text'
