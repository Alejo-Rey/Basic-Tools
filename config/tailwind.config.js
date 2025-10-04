const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        brown: {
          DEFAULT: '#8B4513',
          light: '#A0522D',
          dark: '#654321',
        },
        beige: {
          DEFAULT: '#D4A574',
          light: '#E8D4B8',
          dark: '#B8926A',
        },
        cream: {
          DEFAULT: '#F5E6D3',
          light: '#FFF8F0',
          dark: '#E8D4B8',
        },
        blue: {
          DEFAULT: '#4A90A4',
          light: '#7FB3C4',
          dark: '#2B5F75',
        },
        orange: {
          DEFAULT: '#D97706',
          light: '#F59E0B',
          dark: '#B45309',
        },
        wood: {
          DEFAULT: '#5C4033',
          light: '#7D5A50',
          dark: '#3E2723',
        }
      },
      backgroundImage: {
        'warm': 'linear-gradient(135deg, #D4A574 0%, #E8D4B8 100%)',
        'wood': 'linear-gradient(180deg, #5C4033 0%, #3E2723 100%)',
        'paper': 'linear-gradient(135deg, #F5E6D3 0%, #FFF8F0 50%, #E8D4B8 100%)',
      },
      boxShadow: {
        'warm': '0 4px 14px 0 rgba(139, 69, 19, 0.3)',
        'warm-lg': '0 10px 40px 0 rgba(139, 69, 19, 0.4)',
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ]
}