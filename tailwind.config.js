/** @type {import('tailwindcss').Config} */
// tailwind.config.js
module.exports = {
  content: [
    "./website/views/*.pug",
    "./public/**/*.js",
  ],
  theme: {},
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    //require('daisyui'),
  ],
}


