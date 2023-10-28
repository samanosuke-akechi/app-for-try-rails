I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb, yml}')]
I18n.available_locales = [:ja, :en]
I18n.default_locale = :ja
