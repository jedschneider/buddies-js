{exec} = require 'child_process'

run = (command)->
  exec command, (err,stdout, stderr)->
    throw err if err
    console.log stdout + stderr

compile =(src, dest)->
  run "coffee --bare --compile --output #{dest}/ #{src}/"

task 'build', 'Build project src and spec files', ->
  invoke 'compile:src'
  invoke 'compile:spec'

task 'compile:src', 'Compiles Source CoffeeScripts', ->
  compile("src", "lib")

task 'compile:spec', 'Compiles spec CoffeeScripts', ->
  compile("spec/coffeescripts", "spec/javascripts")

task 'clean', 'removes compiled javascripts', ->
  run 'rm lib/*.js && rm spec/javascripts/*.js'