const purgecss = require('@fullhuman/postcss-purgecss')({

  // Specify the paths to all of the template files in your project
  content: [
    './src/**/*.html',
    './src/elm/**/*.elm'
  ],

  // Include any special characters you're using in this regular expression
  defaultExtractor: content => content.match(/[\w-/:]+(?<!:)/g) || [],
  // These whitelists stop purgecss from removing our computed button colours.
  whitelistPatterns: [
    /black/,
    /white/,
    /gray/,
    /red/,
    /yellow/,
    /green/,
    /blue/,
    /indigo/,
    /purple/
  ]
})

module.exports = {
  plugins: [
    require('tailwindcss'),
    require('autoprefixer'),
    purgecss
  ]
}
