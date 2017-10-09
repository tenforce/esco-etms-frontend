`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'wrapper-terms-manager', 'Integration | Component | wrapper translation addon', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{wrapper-terms-manager}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#wrapper-terms-manager}}
      template block text
    {{/wrapper-terms-manager}}
  """

  assert.equal @$().text().trim(), 'template block text'
