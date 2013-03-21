strings = {}

elements = 'div h1 h2 h3 h4 h5 h6 p li td img span a strong b em i'.split /\s+/

dataSet = (el, key, value) ->
  el.setAttribute "data-t7e-#{key.toLowerCase()}", value

dataGet = (el, key) ->
  el.getAttribute "data-t7e-#{key.toLowerCase()}"

dataAll = (el) ->
  data = {}
  for attr in el.attributes when (attr.name.indexOf 'data-t7e-') is 0
    data[attr.name['data-t7e-'.length...]] = attr.value
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
    translationKey = options[nodeName]

    element = document.createElement nodeName
    element.innerHTML = replaceValues (flatLookup strings, translationKey), options
    dataSet element, 'key', translationKey

    for property, value of options when property isnt nodeName
      if property.charAt(0) is '$'
        dataSet element, "var-#{property[1...]}", value
      else
        dataSet element, "attr-#{property}", value
        element.setAttribute property, translate value

    getOuterHTML element

refresh = (root = document.body) ->
  keyedElements = Array::slice.call root.querySelectorAll '[data-t7e-key]'

  for element in keyedElements
    key = dataGet element, 'key'
    options = {}
    attrs = {}

    for dataAttr, value of dataAll element
      if (dataAttr.indexOf 'var-') is 0
        varName = dataAttr['var-'.length...]
        options["$#{varName}"] = value
      else if (dataAttr.indexOf 'attr-') is 0
        attrName = dataAttr['attr-'.length...]
        attrs[attrName] = value

    element.innerHTML = translate key, options
    element.setAttribute attr, translate value for attr, value of attrs

load = (newStrings...) ->
  for additions in newStrings
    deepMixin strings, additions

t7e = translate
t7e.strings = strings
t7e.deepMixin = deepMixin
t7e.flatLookup = flatLookup
t7e.replaceValues = replaceValues
t7e.getOuterHTML = getOuterHTML
t7e.refresh = refresh
t7e.load = load

window?.t7e = t7e
module?.exports = t7e
