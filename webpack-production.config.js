var path = require("path");
var replace = require("replace");
var webpack = require("webpack");

module.exports = {
  watch: true,
  context: __dirname + '/app',
  entry: {
    main: './main.cjsx'
  },
  output: {
    path: path.join(__dirname, '/public/build', '[hash]'),
    publicPath: '/public/build/[hash]/',
    filename: '[name].[hash].js',
    chunkFilename: '[id].[hash].bundle.js'
  },
  resolve: {
    extensions: ['', '.js', '.cjsx', '.coffee', '.styl']
  },
  module: {
    loaders: [
      { test: /\.cjsx$/, loaders: ['coffee-loader', 'cjsx-loader'] },
      { test: /\.coffee$/, loader: 'coffee-loader' },
      { test: /\.styl$/, loader: 'style-loader!css-loader!stylus-loader!' },
      { test: /\.png$/, loader: 'file-loader' },
      { test: /\.jpg$/, loader: 'file-loader' },
      { test: /\.svg$/, loader: 'file-loader' }
    ],
    noParse: [
      /^react$/
    ]
  },
  node: {
    fs: 'empty'
  },
  watchDelay: 0,
  devtool: 'eval-source-map',
  plugins: [
    function() {
      this.plugin("done", function(stats) {
        require("fs").writeFileSync(
          path.join(__dirname, "public/build", "stats.json"),
          JSON.stringify(stats.toJson())
        );
      });
    }
  ]
};
