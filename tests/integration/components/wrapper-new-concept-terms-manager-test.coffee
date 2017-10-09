`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'wrapper-new-concept-terms-manager', 'Integration | Component | wrapper new concept terms manager', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{wrapper-new-concept-terms-manager}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#wrapper-new-concept-terms-manager}}
      template block text
    {{/wrapper-new-concept-terms-manager}}
  """

  assert.equal @$().text().trim(), 'template block text'
