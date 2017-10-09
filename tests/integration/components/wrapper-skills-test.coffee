`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'wrapper-skills', 'Integration | Component | wrapper skills', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{wrapper-skills}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#wrapper-skills}}
      template block text
    {{/wrapper-skills}}
  """

  assert.equal @$().text().trim(), 'template block text'
