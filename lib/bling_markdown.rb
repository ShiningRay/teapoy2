class BlingMarkdown < Redcarpet::Render::HTML
  def preprocess(text)
    wrap_mentions(text)
  end

  def wrap_mentions(text)
    text.gsub! /(^|\s)(@\w+)/ do
      "#{$1}<span class='mention'>#{$2}</span>"
    end
    text
  end
end