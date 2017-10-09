`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'nav-bar', 'Integration | Component | nav bar', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{nav-bar}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#nav-bar}}
      template block text
    {{/nav-bar}}
  """

  assert.equal @$().text().trim(), 'template block text'
