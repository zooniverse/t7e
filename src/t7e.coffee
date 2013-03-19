strings = {}

elements = 'div h1 h2 h3 h4 h5 h6 p li td span a strong b em i'.split ' '

dataSet = (el, key, value) ->
  el.setAttribute "data-#{key.toLowerCase()}", value

dataGet = (el, key) ->
  el.getAttribute "data-#{key.toLowerCase()}"

dataAll = (el) ->
  data = {}
  for attr in el.attributes when (attr.name.indexOf 'data-') is 0
    data[attr.name['data-'.length...]] = attr.value
  data

deepMixin = (base, mixin) ->
  for own key, value of mixin
    if typeof value is 'string'
      base[key] = value
    else
      base[key] = {} unless key of base
      deepMixin base[key], value

  base

flatLookup = (object, key) ->
  keys = key.split '.'
  object = object[key] for key in keys
  object

replaceValues = (string, values) ->
  for key, value of values when (key.charAt 0) is '$'
    string = string.replace key, value, 'gi'

  string

getOuterHTML = (element) ->
  container = document.createElement 'div'
  container.appendChild element
  container.innerHTML

translate = (params...) ->
  if typeof params[0] is 'string'
    [translationKey, values] = params
    replaceValues (flatLookup strings, translationKey), values

  else
    [options] = params

    nodeName = name for name in elements when name of options
    element = document.createElement nodeName


    translationKey = options[nodeName]
    element.innerHTML = replaceValues (flatLookup strings, translationKey), options
    dataSet element, 'translation-key', translationKey

    for property, value of options when property isnt nodeName
      if property.charAt(0) is '$'
        dataSet element, "translation-var-#{property[1...]}", value
      else
        element.setAttribute property, value

    getOuterHTML element

refresh = (root = document.body) ->
  keyedElements = Array::slice.call root.querySelectorAll '[data-translation-key]'

  for element in keyedElements
    key = dataGet element, 'translation-key'
    options = {}

    for dataAttr, value of dataAll element
      if (dataAttr.indexOf 'translation-var-') is 0
        varName = dataAttr['translation-var-'.length...]
        options["$#{varName}"] = value

    element.innerHTML = translate key, options

load = (newStrings...) ->
  for additions in newStrings
    deepMixin strings, additions

t7e = translate
t7e.deepMixin = deepMixin
t7e.flatLookup = flatLookup
t7e.replaceValues = replaceValues
t7e.getOuterHTML = getOuterHTML
t7e.refresh = refresh
t7e.load = load

module.exports = t7e