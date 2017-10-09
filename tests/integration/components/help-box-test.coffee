`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'help-box', 'Integration | Component | help box', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{help-box}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#help-box}}
      template block text
    {{/help-box}}
  """

  assert.equal @$().text().trim(), 'template block text'
