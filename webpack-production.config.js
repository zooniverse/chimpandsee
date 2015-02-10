var path = require("path");
var webpack = require("webpack");

module.exports = {
  watch: false,
  context: __dirname + '/app',
  entry: {
    main: './main.cjsx'
  },
  output: {
    path: path.join(__dirname, '/public/build'),
    publicPath: '',
    filename: '[name].[hash].js',
    chunkFilename: '[id].[hash].bundle.js'
  },
  resolve: {
    extensions: ['', '.js', 'jsx', '.cjsx', '.coffee']
  },
  module: {
    loaders: [
      { test: /\.cjsx$/, loaders: ['coffee-loader', 'cjsx-loader'] },
      { test: /\.jsx$/, loader: 'jsx-loader'},
      { test: /\.coffee$/, loader: 'coffee-loader' },
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
