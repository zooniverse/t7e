translate = window.t7e

LANGUAGES =
  'en-us':
    hello: 'Hello'
    helloFriend: 'Hello, $friend!'
    goodbye: 'Goodbye'

  'es-mx':
    hello: 'Hola'
    helloFriend: '¡Hola, $friend!'
    goodbye: 'Adios'


# Set up the menu.

select = document.createElement 'select'
for language of LANGUAGES
  option = document.createElement 'option'
  option.value = language
  option.innerHTML = language.toUpperCase()
  select.appendChild option

onLanguageChange = ->
  translate.load LANGUAGES[select.value]
  translate.refresh()

select.addEventListener 'change', onLanguageChange

document.body.appendChild select

onLanguageChange()


# Add some translated content.

container = document.createElement 'div'

container.innerHTML += translate div: 'hello'

container.innerHTML += translate div: 'helloFriend', $friend: 'Aaron'

document.body.appendChild container
