/**
 * @see http://webpack.github.io/docs/configuration.html
 * for webpack configuration options
 */
module.exports = {
  context: __dirname + '/app/assets/javascripts',
  entry: './_application.js',

  output: {
    filename: '[name].bundle.js',
    // We want to save the bundle in the same directory as the other JS.
    path: __dirname + '/app/assets/javascripts'
  },

  // The 'module' and 'loaders' options tell webpack to use loaders.
  // @see http://webpack.github.io/docs/using-loaders.html
  module: {
    loaders: [
      {test: /\.js$/, exclude: /node_modules/, loader: 'babel-loader'},
    ]
  },

  resolve: {
    // you can now require('file') instead of require('file.coffee')
    extensions: ['', '.js', '.json', '.coffee']
  },

  externals: {
    jquery: 'var jQuery'
  }
};
