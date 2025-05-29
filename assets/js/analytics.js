const analytics = _analytics.init({
  app: 'umt-world',
  plugins: [
    // Check what global name the GA plugin actually exports
    analyticsGa.default({
      measurementIds: ['G-5NHX2XP9H3']
    })
  ]
})

/* Track a page view */
analytics.page()

/* Export for global use */
window.analytics = analytics

/* Auto-attach event listeners */
document.addEventListener('DOMContentLoaded', function() {
  // Track external links
  document.querySelectorAll('a[href^="http"]').forEach(link => {
    link.addEventListener('click', () => {
      analytics.track('External Link Click', {
        url: link.href,
        text: link.textContent.trim()
      })
    })
  })
})
