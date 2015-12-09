WebsocketMixin = require('./mixins/WebsocketMixin')

module.exports = Component.create
  displayName: 'Application'

  mixins: [WebsocketMixin]

  getInitialState: ->
    history: new Array()

  componentWillMount: ->
    @connectSocket()

  componentWillUnmount: ->
    @disconnectSocket()

  socketReceivedMessage: (socket, e) ->
    @setState history: @state.history.concat(JSON.parse(e.data))

  socketDidClose: (socket, details) ->
    if details.closedByPeer
      setTimeout (=> @connectSocket()), 1

  historyText: ->
    _.map(@state.history.reverse(), JSON.stringify).join('\n---\n')

  render: ->
    React.DOM.div {},
      React.DOM.textarea
        style:
          width: '100%'
        rows: 50
        value: @historyText()

