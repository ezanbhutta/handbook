// Set the theme before first paint to avoid a flash. Kept as a same-origin file
// (not inline) so the Content-Security-Policy can use a strict `script-src 'self'`
// with no inline-script allowance. Defaults to the clean Day brand; Night and
// Reading are opt-in from the header.
(function () {
  try {
    var t = localStorage.getItem('hb_theme')
    document.documentElement.dataset.theme = t || 'day'
  } catch (e) {
    document.documentElement.dataset.theme = 'day'
  }
})()
