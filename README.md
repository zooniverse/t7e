```coffee
translate = require 't7e'
translate.load greetings: hello: 'Hello', hey: 'Hey, $name!'
```

```coffee
translate span: 'greetings.hello'
# '<span data-translation-key="greetings.hello">Hello</span>'

translate span: 'greetings.hey', $name: 'you'
# '<span data-translation-key="greetings.hey" data-translation-name="you">Hey, you!</span>'
```

```coffee
translate.load greetings: hey: '¡Hola, $name!'
translate.refresh document.body
```
