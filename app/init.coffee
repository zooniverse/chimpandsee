Api = require 'zooniverse/lib/api'
TopBar = require 'zooniverse/controllers/top-bar'
Footer = require 'zooniverse/controllers/footer'

# Api
Api = require 'zooniverse/lib/api'
api = new Api project: 'chimp'

# Top Bar
topBar = new TopBar
document.getElementById('top-bar').appendChild topBar.el[0]

# Footer
footer = new Footer
document.getElementById('footer').appendChild footer.el[0]

