assert = (v, msg) ->
  unless(v)
    throw new Error(msg)