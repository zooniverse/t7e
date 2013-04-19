```coffee
translate = require 't7e'
translate.load greetings: hello: 'Hello', hey: 'Hey, $name!'
```

```coffee
translate 'greetings.hello'
# 'Hello'
```

```coffee
translate 'span', 'greetings.hello'
# '<span data-t7e-key="greetings.hello">Hello</span>'

translate 'span', 'greetings.hey', $name: 'you'
# '<span data-t7e-key="greetings.hey" data-t7e-name="you">Hey, you!</span>'
```

```coffee
translate.load greetings: hey: '¡Hola, $name!'
translate.refresh()
```
