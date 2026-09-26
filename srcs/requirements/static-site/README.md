# Static Portfolio Website

This is a static portfolio website created as part of the Inception project bonus section. The website showcases skills, projects, and contact information using modern HTML, CSS, and JavaScript.

## Features

- **Responsive Design**: Works on all devices from mobile to desktop
- **Modern UI/UX**: Clean, professional design with smooth animations
- **Interactive Elements**: Form validation, smooth scrolling, theme toggle
- **Performance Optimized**: Minified assets, proper caching headers
- **Accessibility**: Semantic HTML, proper contrast ratios, keyboard navigation

## Technology Stack

- **HTML5**: Semantic markup for better accessibility
- **CSS3**: Modern CSS with Flexbox, Grid, and CSS Variables
- **JavaScript (ES6+)**: Interactive features and animations
- **Font Awesome**: Icon library
- **Google Fonts**: Poppins and Roboto Mono typography

## Project Structure

```
static-site/
├── Dockerfile              # Container configuration
├── conf/
│   └── nginx.conf         # Nginx server configuration
└── html/                  # Website source files
    ├── index.html         # Main HTML document
    ├── css/
    │   └── style.css      # All styles
    └── js/
        └── script.js      # All JavaScript functionality
```

## Pages & Sections

1. **Home**: Hero section with introduction and animated code block
2. **About**: Personal information and statistics counters
3. **Skills**: Technical skills with interactive cards
4. **Projects**: Featured projects with technology tags
5. **Contact**: Contact form and information

## Interactive Features

- **Smooth Scrolling**: Navigation links scroll smoothly to sections
- **Form Validation**: Contact form with client-side validation
- **Theme Toggle**: Light/dark mode toggle button
- **Animations**: Fade-in animations on scroll
- **Responsive Navigation**: Mobile-friendly hamburger menu
- **Active Navigation**: Highlights current section in navigation

## Docker Configuration

The website is served using Nginx in an Alpine Linux container for minimal footprint and fast startup times.

## Deployment

This website is automatically deployed as part of the Inception project infrastructure and is accessible at `http://static.oussama.42.fr`.

## Development

To modify the website:
1. Edit files in the `html/` directory
2. Test locally by opening `index.html` in a browser
3. Rebuild the Docker image: `docker-compose build static-site`
4. Restart the container: `docker-compose restart static-site`

## Performance Notes

- Images are optimized and served with proper caching headers
- CSS and JavaScript are minified in production
- Gzip compression is enabled for all text assets
- Fonts are loaded from CDN for better performance