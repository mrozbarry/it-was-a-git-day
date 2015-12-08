WebsocketMixin = require('./mixins/WebsocketMixin')

module.exports = Component.create
  displayName: 'Application'

  mixins: [WebsocketMixin]

  getInitialState: ->
    new Array()

  componentWillMount: ->

  componentWillUnmount: ->

  render: ->
    React.DOM.div {},
      React.DOM.textarea {},
        _.map @state, (line) ->
          "#{line}\n"

