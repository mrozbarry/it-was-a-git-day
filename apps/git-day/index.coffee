
require('./styles/index.sass')
Application = require('./Application')

container = document.createElement('div')
document.body.appendChild(container)

ReactDOM.render(
  Application(null)
  container
)

