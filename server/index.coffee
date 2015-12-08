GithubAdaptor = require('./adaptors/GithubAdaptor')

http = require("http")
express = require("express")
path = require("path")

publicPath = path.resolve(__dirname, '..', 'public')

app = express()

app.set 'port', process.env.PORT || 5000

development = -> process.env.NODE_ENV != 'production'

app.use express.static(publicPath)

if development()
  Webpack = require("webpack")
  WebpackDevMiddleware = require("webpack-dev-middleware")
  WebpackHotMiddleware = require("webpack-hot-middleware")
  webpackConfig = require("../config/webpack.config.js")

  console.log 'Application is not in production mode, activating middleware...'
  compiler = Webpack(webpackConfig)

  console.log ' -> Webpack Dev Middleware'
  app.use WebpackDevMiddleware(compiler,
    publicPath: webpackConfig.output.publicPath
    contentBase: "assets/scripts"
    stats: {
      colors: true
      hash: false
      timings: true
      chunks: false
      chunkModules: false
      modules: false
    },
  )
  console.log ' -> Webpack Hot Middleware'
  app.use WebpackHotMiddleware(compiler)
else
  console.log '***=== Application is in production mode ===***'


server = http.createServer(app)
server.listen app.get('port'), ->
  console.log "http server listening on %d", app.get('port')

# ---
# Instantiate Adaptors Here!
# ---

GithubAdaptor(app, engine)

# ---
# Default route to the app for lazy people
# ---

app.get '*', (req, res) ->
  res.sendFile path.join(__dirname, '..', 'public', 'index.html')

