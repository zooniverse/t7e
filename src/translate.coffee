strings = {}

elements = ['div', 'p', 'li', 'td', 'span', 'a', 'strong', 'em']

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
    string = string.replace key, value, 'g'

  string

getOuterHTML = (element) ->
  container = document.createElement 'div'
  container.appendChild element
  container.innerHTML

upcase = (string) ->
  string.charAt(0).toUpperCase() + string[1...]

downcase = (string) ->
  string.charAt(0).toLowerCase() + string[1...]

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
    element.dataset.translationKey = translationKey

    for property, value of options when property isnt nodeName
      if property.charAt(0) is '$'
        element.dataset["translationVar#{upcase property[1...]}"] = value
      else
        element.setAttribute property, value

    getOuterHTML element

refresh = (root = document.body) ->
  elements = Array::slice.call root.querySelectorAll '[data-translation-key]'

  for element in elements
    key = element.dataset.translationKey
    options = {}
    for dataAttr, value of element.dataset
      if (dataAttr.indexOf 'translationVar') is 0
        varName = dataAttr[14...]
        options["$#{downcase varName}"] = value

    element.innerHTML = translate key, options

load = (newStrings...) ->
  for additions in newStrings
    deepMixin strings, additions

translate.deepMixin = deepMixin
translate.flatLookup = flatLookup
translate.replaceValues = replaceValues
translate.getOuterHTML = getOuterHTML
translate.refresh = refresh
translate.load = load

module.exports = translate
