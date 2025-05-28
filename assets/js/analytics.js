// Initialize analytics with your existing GA measurement ID
const analytics = _analytics.init({
 app: 'umt-world',
 debug: true, // Set to true during development
 plugins: [
   googleAnalytics({
     measurementIds: ['G-5NHX2XP9H3']
   })
 ]
})

// Auto-track page views
analytics.page()

// Enhanced event tracking functions
analytics.trackExternalLink = function(url, text) {
 this.track('External Link Click', {
   url: url,
   text: text,
   category: 'outbound'
 })
}

analytics.trackDownload = function(filename, type) {
 this.track('File Download', {
   filename: filename,
   file_type: type,
   category: 'downloads'
 })
}

analytics.trackReadingProgress = function(percentage, title) {
 this.track('Reading Progress', {
   percentage: percentage,
   page_title: title,
   category: 'engagement'
 })
}

// Export globally
window.analytics = analytics

// Auto-attach event listeners when DOM loads
document.addEventListener('DOMContentLoaded', function() {
 // Track external links
 document.querySelectorAll('a[href^="http"]').forEach(link => {
   link.addEventListener('click', () => {
     analytics.trackExternalLink(link.href, link.textContent.trim())
   })
 })

 // Track internal navigation
 document.querySelectorAll('a[href^="/"]').forEach(link => {
   link.addEventListener('click', () => {
     analytics.track('Internal Navigation', {
       destination: link.href,
       text: link.textContent.trim(),
       category: 'navigation'
     })
   })
 })

 // Track reading progress
 let lastProgress = 0
 window.addEventListener('scroll', () => {
   const progress = Math.round((window.scrollY / (document.body.scrollHeight - window.innerHeight)) * 100)
   if (progress > lastProgress + 25 && progress <= 100) {
     lastProgress = progress
     analytics.trackReadingProgress(progress, document.title)
   }
 })
})
