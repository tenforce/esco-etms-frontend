`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'concept-creator', 'Integration | Component | concept creator', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{concept-creator}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#concept-creator}}
      template block text
    {{/concept-creator}}
  """

  assert.equal @$().text().trim(), 'template block text'
