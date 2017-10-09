`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'notification-related-item', 'Integration | Component | notification related item', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{notification-related-item}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#notification-related-item}}
      template block text
    {{/notification-related-item}}
  """

  assert.equal @$().text().trim(), 'template block text'
