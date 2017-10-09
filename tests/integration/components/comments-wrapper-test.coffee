`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'comments-wrapper', 'Integration | Component | comments wrapper', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{comments-wrapper}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#comments-wrapper}}
      template block text
    {{/comments-wrapper}}
  """

  assert.equal @$().text().trim(), 'template block text'
