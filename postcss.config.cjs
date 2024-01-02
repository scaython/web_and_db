// postcss.config.cjs
const autoprefixer = require('autoprefixer');
const tailwindcss = require('tailwindcss');
const daisyui = require('daisyui');

module.exports = {
  plugins: [
    tailwindcss,
    //daisyui,
    autoprefixer,
  ],
};
