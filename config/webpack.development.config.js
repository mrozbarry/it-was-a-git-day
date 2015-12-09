var baseConfig = require('./webpack.base.config.js');
baseConfig.devtool = 'eval-source-map';
baseConfig.entry.bundle.push("webpack-hot-middleware/client");

module.exports = baseConfig;
