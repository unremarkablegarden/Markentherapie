axis         = require 'axis'
rupture      = require 'rupture'
autoprefixer = require 'autoprefixer-stylus'
js_pipeline  = require 'js-pipeline'
css_pipeline = require 'css-pipeline'
jeet         = require 'jeet'

module.exports =
  ignores: ['readme.md', '**/layout.*', '**/_*', '.gitignore', 'ship.*conf', '.DS_Store', 'sendgrid.env', '.htaccess', '_content']

  extensions: [
    js_pipeline(files: 'assets/js/*.coffee', out: 'js/build.js', minify: true, hash: true),
    css_pipeline(files: 'assets/css/*.styl', out: 'css/build.css', minify: true, hash: true)
  ]

  stylus:
    use: [axis(), rupture(), jeet(), autoprefixer()]

  locals:
    jquery: '//cdnjs.cloudflare.com/ajax/libs/jquery/3.1.0/jquery.min.js'
    jqueryui: '//cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.0/jquery-ui.min.js'
