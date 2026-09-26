// DOM Elements
const hamburger = document.querySelector('.hamburger');
const navLinks = document.querySelector('.nav-links');
const contactForm = document.getElementById('contactForm');
const sections = document.querySelectorAll('section');
const navItems = document.querySelectorAll('.nav-links a');

// Mobile Navigation Toggle
hamburger.addEventListener('click', () => {
    navLinks.style.display = navLinks.style.display === 'flex' ? 'none' : 'flex';
});

// Close mobile menu when clicking outside
document.addEventListener('click', (e) => {
    if (!hamburger.contains(e.target) && !navLinks.contains(e.target)) {
        navLinks.style.display = 'none';
    }
});

// Smooth scrolling for navigation links
navItems.forEach(item => {
    item.addEventListener('click', (e) => {
        e.preventDefault();
        const targetId = item.getAttribute('href');
        const targetSection = document.querySelector(targetId);
        
        if (targetSection) {
            // Close mobile menu if open
            if (window.innerWidth <= 768) {
                navLinks.style.display = 'none';
            }
            
            // Smooth scroll to section
            window.scrollTo({
                top: targetSection.offsetTop - 80,
                behavior: 'smooth'
            });
        }
    });
});

// Contact form submission
if (contactForm) {
    contactForm.addEventListener('submit', (e) => {
        e.preventDefault();
        
        // Get form data
        const formData = new FormData(contactForm);
        const name = formData.get('name') || 'User';
        
        // Show success message (in a real implementation, this would send to a server)
        alert(`Thank you ${name}! Your message has been sent successfully. I'll get back to you soon!`);
        
        // Reset form
        contactForm.reset();
    });
}

// Intersection Observer for animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('fade-in');
            observer.unobserve(entry.target);
        }
    });
}, observerOptions);

// Observe all sections for animation
sections.forEach(section => {
    observer.observe(section);
});

// Active navigation item based on scroll position
window.addEventListener('scroll', () => {
    let current = '';
    
    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.clientHeight;
        
        if (scrollY >= (sectionTop - 150)) {
            current = section.getAttribute('id');
        }
    });
    
    navItems.forEach(item => {
        item.classList.remove('active');
        if (item.getAttribute('href') === `#${current}`) {
            item.classList.add('active');
        }
    });
});

// Theme toggle (optional enhancement)
const createThemeToggle = () => {
    const themeToggle = document.createElement('button');
    themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
    themeToggle.className = 'theme-toggle';
    themeToggle.style.cssText = `
        position: fixed;
        bottom: 20px;
        right: 20px;
        width: 50px;
        height: 50px;
        border-radius: 50%;
        background: var(--primary-color);
        color: white;
        border: none;
        cursor: pointer;
        z-index: 1000;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.2rem;
        box-shadow: var(--box-shadow);
        transition: var(--transition);
    `;
    
    document.body.appendChild(themeToggle);
    
    themeToggle.addEventListener('click', () => {
        document.body.classList.toggle('dark-theme');
        const icon = themeToggle.querySelector('i');
        if (document.body.classList.contains('dark-theme')) {
            icon.className = 'fas fa-sun';
            // Add dark theme styles dynamically
            document.documentElement.style.setProperty('--dark-color', '#f8fafc');
            document.documentElement.style.setProperty('--light-color', '#1e293b');
        } else {
            icon.className = 'fas fa-moon';
            // Reset to light theme
            document.documentElement.style.setProperty('--dark-color', '#1e293b');
            document.documentElement.style.setProperty('--light-color', '#f8fafc');
        }
    });
};

// Initialize theme toggle
createThemeToggle();

// Dynamic stats counter
const stats = document.querySelectorAll('.stat h3');
const animateValue = (element, start, end, duration) => {
    let startTimestamp = null;
    const step = (timestamp) => {
        if (!startTimestamp) startTimestamp = timestamp;
        const progress = Math.min((timestamp - startTimestamp) / duration, 1);
        element.textContent = Math.floor(progress * (end - start) + start);
        if (progress < 1) {
            window.requestAnimationFrame(step);
        }
    };
    window.requestAnimationFrame(step);
};

// Animate stats when they come into view
const statsObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            const statElement = entry.target;
            const targetValue = parseInt(statElement.textContent);
            animateValue(statElement, 0, targetValue, 2000);
            statsObserver.unobserve(statElement);
        }
    });
}, { threshold: 0.5 });

stats.forEach(stat => statsObserver.observe(stat));

// Responsive navigation
window.addEventListener('resize', () => {
    if (window.innerWidth > 768) {
        navLinks.style.display = 'flex';
    } else {
        navLinks.style.display = 'none';
    }
});

// Initialize on page load
document.addEventListener('DOMContentLoaded', () => {
    // Set current year in footer
    const yearElement = document.querySelector('.footer-copyright');
    if (yearElement) {
        const currentYear = new Date().getFullYear();
        yearElement.textContent = yearElement.textContent.replace('2024', currentYear);
    }
    
    // Add active class to first nav item
    if (navItems.length > 0) {
        navItems[0].classList.add('active');
    }
});

// Add CSS for active nav item
const style = document.createElement('style');
style.textContent = `
    .nav-links a.active {
        color: var(--primary-color) !important;
        background: rgba(37, 99, 235, 0.1) !important;
    }
    
    .dark-theme {
        background: #0f172a;
        color: #f1f5f9;
    }
    
    .dark-theme .skill-card,
    .dark-theme .project-card,
    .dark-theme .contact-item,
    .dark-theme .contact-form,
    .dark-theme .stat {
        background: #1e293b;
        color: #f1f5f9;
    }
    
    .dark-theme .skill-card h3,
    .dark-theme .project-card h3,
    .dark-theme .contact-item h3,
    .dark-theme .stat h3 {
        color: #f1f5f9;
    }
    
    .dark-theme .skill-card p,
    .dark-theme .project-card p,
    .dark-theme .contact-item p,
    .dark-theme .stat p {
        color: #cbd5e1;
    }
`;
document.head.appendChild(style);