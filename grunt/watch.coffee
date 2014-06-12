##* Grunt Contrib Watch
module.exports =
  tests:
    files: ['test/specs/**/*.coffee']
    tasks: ['tests']
  styles:
    files: ['scss/**/*.scss']
    tasks: [
      'sass:develop'
      'autoprefixer:theme'
      # 'csscss:theme'
      # 'csslint:theme'
      'cssmin:theme'
    ]
  coffee:
    files: ['src/**/*.{coffee,js}']
    tasks: [
      'coffeelint:theme'
      'browserify:theme'
      'concat:banner'
      'uglify:js'
    ]
