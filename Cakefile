exec = require 'easy-exec'

task 'serve', (options) ->
  exec "silver server --port #{process.env.PORT || 7373}"
  exec 'coffee --watch --output . --compile ./src'
  exec 'stylus --watch ./src --out .'
