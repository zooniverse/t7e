translate = require '../src/translate'
{deepMixin, flatLookup, replaceValues, getOuterHTML} = translate

describe 'deepMixin', ->
  it 'mixes deeply', ->
    original = foo: 'old'
    mixin = foo: 'new', bar: 'bar'
    deepMixin original, mixin
    (expect original.foo).toBe 'new'

describe 'flatLookup', ->
  it 'looks up strings', ->
    strings = greetings: hello: 'Hello!'
    helloGreeting = flatLookup strings, 'greetings.hello'
    (expect helloGreeting).toBe 'Hello!'

describe 'replaceValues', ->
  it 'replaces provided "$"-prefixed words in a string', ->
    raw = 'Hello, $planet!'
    replaced = replaceValues raw, $planet: 'Earth'
    (expect replaced).toBe 'Hello, Earth!'

describe 'getOuterHTML', ->
  it 'returns a node as a string', ->
    div = document.createElement 'div'
    div.innerHTML = 'inner'
    outer = getOuterHTML div
    (expect outer).toBe '<div>inner</div>'

describe 'translate.load', ->
  it 'loads new strings', ->
    translate.load hello: 'Hello'
    (expect translate 'hello').toBe 'Hello'

describe 'translate', ->
  it 'translates into an element as a string', ->
    translate.load hello: 'Hello, $what!'
    html = translate span: 'hello', $what: 'world'
    (expect !!~html.indexOf 'Hello, world!').toBe true

describe 'translate.refresh', ->
  it 'refreshses existing elements', ->
    translate.load hello: 'Hello, $what!'
    container = document.createElement 'div'
    document.body.appendChild container
    container.innerHTML = translate span: 'hello', $what: 'world'
    (expect !!~container.innerHTML.indexOf 'Hello, world!').toBe true
    translate.load hello: '¡Hola, $what!'
    translate.refresh()
    (expect !!~container.innerHTML.indexOf '¡Hola, world!').toBe true
    container.parentNode.removeChild container
