`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'concept-bookmark', 'Integration | Component | concept bookmark', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{concept-bookmark}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#concept-bookmark}}
      template block text
    {{/concept-bookmark}}
  """

  assert.equal @$().text().trim(), 'template block text'
