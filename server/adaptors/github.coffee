module.exports = (app, engine) ->
  app.get '/github_callback', (req, res) ->
    switch req.headers['X-Github-Event']
      when 'push'
        # TODO
      when 'release'
        # TODO
      when 'create'
        # TODO
