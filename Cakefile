{spawn} = require 'child_process'

exec = (fullCommand) ->
  [command, args...] = fullCommand.split ' '
  child = spawn command, args
  child.stdout.on 'data', process.stdout.write.bind process.stdout
  child.stderr.on 'data', process.stderr.write.bind process.stderr

task 'serve', (options) ->
  exec 'coffee --watch --output . --compile src/t7e.coffee'
  exec "silver server --port #{process.env.PORT || 7373}"
