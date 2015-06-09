# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile +=  %w(tip-twitter.css screen.css
    style.css ie.css handheld.css print.css mobile.css mobile.js mobile2.js
    plugins.js
    admin.css admin.js
    vendor/dd_belatedpng.js
    my.css
    mobile_old.css
    dist/*.js
    dist/*.css
)
