const {
  environment
} = require('@rails/webpacker')
const {
  VueLoaderPlugin
} = require('vue-loader')
const vue = require('./loaders/vue')
const webpack = require('webpack')

var LodashModuleReplacementPlugin = require('lodash-webpack-plugin');
environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
// environment.plugins.prepend('LodashModuleReplacement', new LodashModuleReplacementPlugin)

// fix legacy jQuery plugins which depend on globals
environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',
    onmount: 'onmount',
    moment: 'moment'
  })
)

environment.loaders.prepend('vue', vue)

module.exports = environment