Api = require 'zooniverse/lib/api'
TopBar = require 'zooniverse/controllers/top-bar'
Footer = require 'zooniverse/controllers/footer'
LanguageManager = require 'zooniverse/lib/language-manager'
Subject = require 'zooniverse/models/subject'
$ = window.jQuery

# Api
Api = require 'zooniverse/lib/api'
api = new Api project: 'chimp'

Subject.group = true

$(document).ready(
  # Top Bar
  topBar = new TopBar
  document.getElementById('top-bar').appendChild topBar.el[0]

  # Footer
  footer = new Footer
  document.getElementById('footer').appendChild footer.el[0]
)

LanguageManager = require 'zooniverse/lib/language-manager'
#languageManager = new LanguageManager
#  translations:
#    en: label: 'English', strings: enUs

#languageManager.on 'change-language', (e, code, strings) ->
#  translate.load strings
#  translate.refresh()