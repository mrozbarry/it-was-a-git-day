var baseConfig = require('./webpack.base.config.js');
baseConfig.devtool = 'eval';

module.exports = baseConfig;
