`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'wrapper-nace', 'Integration | Component | wrapper nace', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{wrapper-nace}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#wrapper-nace}}
      template block text
    {{/wrapper-nace}}
  """

  assert.equal @$().text().trim(), 'template block text'
