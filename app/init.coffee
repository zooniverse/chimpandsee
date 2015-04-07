$ = window.jQuery

# Api
Api = require 'zooniverse/lib/api'
api = new Api project: 'chimp'

# Subject group setup
Subject = require 'zooniverse/models/subject'
Subject.group = true

# Top Bar
TopBar = require 'zooniverse/controllers/top-bar'
topBar = new TopBar
document.getElementById('top-bar').appendChild topBar.el[0]

# Google Analytics
GoogleAnalytics = require 'zooniverse/lib/google-analytics'
new GoogleAnalytics
  account: 'UA-1224199-17'
  domain: 'chimpandsee.org'


