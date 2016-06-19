// Common client-side webpack configuration used by webpack.hot.config and webpack.rails.config.

const webpack = require('webpack');
const path = require('path');

const devBuild = process.env.NODE_ENV !== 'production';
const nodeEnv = devBuild ? 'development' : 'production';

module.exports = {

  // the project dir
  context: __dirname,
  entry: {

    // See use of 'vendor' in the CommonsChunkPlugin inclusion below.
    vendor: [
      'jquery',
    ],

    react: [
      'react',
      'redux',
      'react-redux',
      'mirror-creator',
      'react-on-rails',
      'babel-polyfill',
    ],

    'schedule-list': './app/bundles/ScheduleList/startup/clientRegistration',

    'certificate-assignments': './app/bundles/CertificateAssignments/startup/client-registration',
  },
  resolve: {
    extensions: ['', '.js', '.jsx'],
    alias: {
      lib: path.join(process.cwd(), 'app', 'lib'),
      react: path.resolve('./node_modules/react'),
      'react-dom': path.resolve('./node_modules/react-dom'),
    },
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: JSON.stringify(nodeEnv),
      },
    }),

    // https://webpack.github.io/docs/list-of-plugins.html#2-explicit-vendor-chunk
    new webpack.optimize.CommonsChunkPlugin({

      // This name 'vendor' ties into the entry definition
      names: ['react', 'vendor'],

      // We don't want the default vendor.js name
      filename: '[name]-bundle.js',

      // Passing Infinity just creates the commons chunk, but moves no modules into it.
      // In other words, we only put what's in the vendor entry definition in vendor-bundle.js
      minChunks: Infinity,
    }),
  ],
  module: {
    loaders: [

      // Not all apps require jQuery. Many Rails apps do, such as those using TurboLinks or
      // bootstrap js
      { test: require.resolve('jquery'), loader: 'expose?jQuery' },
      { test: require.resolve('jquery'), loader: 'expose?$' },
    ],
  },
};
