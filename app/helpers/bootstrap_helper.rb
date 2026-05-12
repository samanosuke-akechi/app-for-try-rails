module BootstrapHelper
  def bootstrap_css_link
    tag.link(
      href: 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css',
      rel: 'stylesheet',
      integrity: 'sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM',
      crossorigin: 'anonymous'
    )
  end

  def bootstrap_icons_css_link
    tag.link(
      href: 'https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css',
      rel: 'stylesheet'
    )
  end

  def bootstrap_javascript_tag
    tag.script(
      src: 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js',
      integrity: 'sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz',
      crossorigin: 'anonymous'
    )
  end
end
