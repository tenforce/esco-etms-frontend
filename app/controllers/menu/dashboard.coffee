`import Ember from 'ember'`
`import env from '../../config/environment'`
`import UserRights from '../../mixins/user-rights'`

DashboardController = Ember.Controller.extend UserRights,

  init: ->
    @_super()
    @refresh(false)

  refresh: (force) ->
    @kpiTotalOccupations(force)
    @kpiTotalSkills(force)
    @kpiTotalKnowledges(force)
    @kpiIscoGroups(force)
    @kpiSkillGroups(force)
    @kpiKnowledgeGroups(force)
    @kpiOccupationsStatus(force)
    @kpiSkillsStatus(force)
    @kpiKnowledgesStatus(force)

  # Set in the router
  display: null
  colors:
    [
      'rgb(158,1,66)',
      'rgb(213,62,79)',
      'rgb(244,109,67)',
      'rgb(253,174,97)',
      'rgb(254,224,139)',
      'rgb(230,245,152)',
      'rgb(171,221,164)',
      'rgb(102,194,165)',
      'rgb(50,136,189)',
      'rgb(94,79,162)',
      '#C38EC7',
      '#B6B6B4',
      '#FFA62F',
      '#FBBBB9',
      '#7F525D',
      '#7F5217',
      '#F62217',
      '#CC6600',
      '#25383C',
      '#C7A317',
      '#C24641',
      '#54C571',
      '#89C35C',
      '#FFD801',
      '#6F4E37',
      '#E6A9EC',
      '#306754',
      '#566D7E',
      '#614051',
      '#CCFB5D',
      '#2B547E',
      '#50EBEC',
      '#C35817',
      '#9F000F',
      '#6C2DC7',
      '#4AA417',
      '#FFE5B4',
      '#E2A76F',
      '#C68E17',
      '#151B54',
      '#FF7F50',
      '#000080',
      '#EDC9AF',
      '#800517',
      '#3BB9FF',
      '#FFF8DC',
      '#CA226B',
      '#4E8975',
      '#387C44',
      '#F75D59',
      '#F9B7FF',
      '#82CAFF',
      '#BCC6CC',
      '#EDDA74',
      '#B2C248',
      '#726E6D',
      '#E9CFEC',
      '#810541',
      '#FFF380',
      '#EDDA74',
      '#4863A0',
      '#E4287C',
      '#9E7BFF',
      '#3090C7',
      '#F87217',
      '#FC6C85',
      '#3EA99F',
      '#78866B',
      '#EBDDE2',
      '#FFF5EE',
      '#C11B17',
      '#C34A2C',
      '#CCFFFF',
      '#46C7C7',
      '#2B3856',
      '#806517',
      '#E18B6B',
      '#F3E5AB',
      '#0020C2',
      '#FFF8C6',
      '#4C4646',
      '#7F462C',
      '#657383',
      '#571B7E',
      '#ECC5C0',
      '#617C58',
      '#C04000',
      '#737CA1',
      '#728C00',
      '#95B9C7',
      '#254117',
      '#1589FF',
      '#B1FB17',
      '#CD7F32',
      '#78C7C7',
      '#008080',
      '#2B60DE',
      '#954535',
      '#F2BB66',
      '#307D7E',
      '#6AA121',
      '#98AFC7',
      '#E3E4FA',
      '#347235',
      '#D462FF'
    ]

  annotationCalculator: (res) ->
    data = res.get("firstObject")
    annotations = []
    if (data.x.length > 0) and (data.y.length > 0)
      size = 11
      if data.x.length > 15
        size = 10
      for item, i in data.x
        result = {
          x: item,
          y: data.y[i],
          text: data.y[i] + ' (' + item + ')',
          font: {
            size: size,
            color: 'rgba(0,0,0,1)'
          },
          xanchor: 'left',
          showarrow: false
        }
        annotations.push(result)
    annotations
  groupCalculator: (res) ->
    values= []
    labels= []
    unless res is undefined or res is 'loading'
      res.forEach (item) ->
        labels.push "#{item?.attributes?.id}: #{item?.attributes?.label}"
        values.push item?.attributes?.total
    return [{
      marker:
        color: @get('colors'),
      type:"bar",
      x:values,
      y:labels,
      text:labels,
      orientation: 'h'
      }]
  skillGroupCalculator: (res, type) ->
    values= []
    labels= []
    unless res is undefined or res is 'loading'
      res.forEach (item) ->
        unless labels.contains "#{item?.attributes?.id}: #{item?.attributes?.label}"
          labels.push "#{item?.attributes?.id}: #{item?.attributes?.label}"
          values.push item?.attributes?.total
    return [{
      marker:
        color: @get('colors'),
      type:"bar",
      x:values,
      y:labels,
      text:labels,
      orientation: 'h'
      }]

  statusCalculator: (res) ->
    # res = @get("#{text}")
    values= []
    labels= []
    unless res is undefined or res is 'loading'
      res.forEach (item) ->
        labels.push item?.attributes?.status
        values.push item?.attributes?.total
    return [{
      marker:
        color: @get('colors'),
      type:"bar",
      x:values,
      y:labels,
      text:labels,
      orientation: 'h'
      }]


  actions:
    refresh: (force) ->
      @refresh(force)
    toDisplay: (display) ->
      @set('display', display)

  resTotalOccupations: "loading"
  kpiTotalOccupations: (force) ->
    kpi = "e55f2de0-ea7f-49a3-bd88-8acd1eb60c41"
    params = {scheme: env.etms.occupationScheme, editable: "true", type: "Occupation"}
    @runKPI(kpi, params, force, 'resTotalOccupations')
  totalOccupations: Ember.computed 'resTotalOccupations', ->
    varname = 'resTotalOccupations'
    res = @get(varname)
    if res is "loading" then return 0
    else if res is undefined then return 0
    else return res[0]?.attributes?.total || 0

  resIscoGroups: "loading"
  kpiIscoGroups: (force) ->
    kpi = "5e08b8e5-cd68-46f8-9f5f-a96a073d65c7"
    params = {scheme: env.etms.occupationScheme, editable: "true", type: "Occupation"}
    @runKPI(kpi, params, force, 'resIscoGroups')
  iscoGroups: Ember.computed 'resIscoGroups', ->
    @groupCalculator(@get('resIscoGroups'))
  iscoGroupsAnnotation: Ember.computed 'iscoGroups', ->
    @annotationCalculator(@get('iscoGroups'))

  resOccupationsStatus: "loading"
  kpiOccupationsStatus: (force) ->
    kpi = "f9fe2390-066c-4193-ae46-492958868d1f"
    params = {scheme: env.etms.occupationScheme, editable: "true", type: "Occupation"}
    @runKPI(kpi, params, force, 'resOccupationsStatus')
  occupationsStatus: Ember.computed 'resOccupationsStatus', ->
    @statusCalculator(@get('resOccupationsStatus'))
  occupationsStatusAnnotation: Ember.computed 'occupationsStatus', ->
    @annotationCalculator(@get('occupationsStatus'))

  resTotalSkills: "loading"
  kpiTotalSkills: (force) ->
    kpi = "37f8f7c9-ca85-4a4a-b9d5-0492a44522f4"
    params = {scheme: env.etms.skillScheme, editable: "true", type: "Skill", skilltype: "skill", direction:"clockwise"}
    @runKPI(kpi, params, force, 'resTotalSkills')
  totalSkills: Ember.computed 'resTotalSkills', ->
    varname = 'resTotalSkills'
    res = @get(varname)
    if res is "loading" then return 0
    else if res is undefined then return 0
    else return res[0]?.attributes?.total || 0

  resTotalKnowledges: "loading"
  kpiTotalKnowledges: (force) ->
    kpi = "37f8f7c9-ca85-4a4a-b9d5-0492a44522f4"
    params = {scheme: env.etms.skillScheme, editable: "true", type: "Skill", skilltype: "knowledge", direction:"clockwise"}
    @runKPI(kpi, params, force, 'resTotalKnowledges')
  totalKnowledges: Ember.computed 'resTotalKnowledges', ->
    varname = 'resTotalKnowledges'
    res = @get(varname)
    if res is "loading" then return 0
    else if res is undefined then return 0
    else return res[0]?.attributes?.total || 0

  resSkillGroups: "loading"
  kpiSkillGroups: (force) ->
    kpi = "acfee2a8-f720-42c1-b78f-727bca607606"
    params = {scheme: env.etms.skillScheme, editable: "true", type: "Skill", skilltype: "skill"}
    @runKPI(kpi, params, force, 'resSkillGroups')
  skillGroups: Ember.computed 'resSkillGroups', ->
    @skillGroupCalculator(@get('resSkillGroups'), "skill")
  skillGroupsAnnotation: Ember.computed 'skillGroups', ->
    @annotationCalculator(@get('skillGroups'))

  resKnowledgeGroups: "loading"
  kpiKnowledgeGroups: (force) ->
    kpi = "acfee2a8-f720-42c1-b78f-727bca607606"
    params = {scheme: env.etms.skillScheme, editable: "true", type: "Skill", skilltype: "knowledge"}
    @runKPI(kpi, params, force, 'resKnowledgeGroups')
  knowledgeGroups: Ember.computed 'resKnowledgeGroups', ->
    @skillGroupCalculator(@get('resKnowledgeGroups'), "knowledge")
  knowledgeGroupsAnnotation: Ember.computed 'knowledgeGroups', ->
    @annotationCalculator(@get('knowledgeGroups'))

  resSkillsStatus: "loading"
  kpiSkillsStatus: (force) ->
    kpi = "e77d267e-baa5-4427-9298-e91f1f5e6a62"
    params = {scheme: env.etms.skillScheme, editable: "true", type: "Skill", skilltype: "skill"}
    @runKPI(kpi, params, force, 'resSkillsStatus')
  skillsStatus: Ember.computed 'resSkillsStatus', ->
    @statusCalculator(@get('resSkillsStatus'))
  skillsStatusAnnotation: Ember.computed 'skillsStatus', ->
    @annotationCalculator(@get('skillsStatus'))

  resKnowledgesStatus: "loading"
  kpiKnowledgesStatus: (force) ->
    kpi = "e77d267e-baa5-4427-9298-e91f1f5e6a62"
    params = {scheme: env.etms.skillScheme, editable: "true", type: "Skill", skilltype: "knowledge"}
    @runKPI(kpi, params, force, 'resKnowledgesStatus')
  knowledgesStatus: Ember.computed 'resKnowledgesStatus', ->
    @statusCalculator(@get('resKnowledgesStatus'))
  knowledgesStatusAnnotation: Ember.computed 'knowledgesStatus', ->
    @annotationCalculator(@get('knowledgesStatus'))

  runKPI: (kpi, params, force, varname) ->
    data = {}
    Object.keys(params).forEach (key) ->
      data["kpi-#{key}"] = params[key]
    # TODO use Ember ajax service
    Ember.$.ajax({
      url: "/kpis/#{kpi}/run?bypassCache=#{force}",
      crossDomain: true,
      type: "GET",
      data: data
    }).then (response) =>
      if response then @set varname, (response?.data?.relationships?.observations?.data || undefined)
      else @set varname, undefined

`export default DashboardController`
