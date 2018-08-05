require 'rss'
require 'cgi'

RE_FIND = /design\spattern/i
LANGS = %w[Ruby JavaScript Python C# Java C++].freeze
OUTPUT_FORMAT = '%.2f %% (%d/%d)'.freeze

def contains?(text, str)
  text =~ /#{Regexp.quote(str)}/i
end

def query_escape(str)
  CGI.escape(str.downcase)
end

def html_escape(str)
  CGI.unescapeHTML(str)
end

def langs_without(current_lang)
  LANGS.reject { |lang| lang == current_lang }
end

LANGS.each do |current_lang|
  print "#{current_lang}: "

  tag = query_escape(current_lang)
  url = "https://stackoverflow.com/jobs/feed?q=#{tag}"
  rss = RSS::Parser.parse(url, false)

  total = rss.items.size
  matched = rss.items.count do |item|
    escaped_title = html_escape(item.title)
    escaped_descr = html_escape(item.description)
    other_langs = langs_without(current_lang)

    title_has_other_langs = other_langs.any? { |lang| contains?(escaped_title, lang) }
    title_has_current_lang = escaped_title.include?(current_lang)
    title_matched = title_has_other_langs ? title_has_current_lang : true
    description_has_current_lang = escaped_descr.include?(current_lang)
    description_has_patterns = escaped_descr =~ RE_FIND
    cats_have_current_lang = item.categories.any? { |c| contains?(c.to_s, current_lang) }

    cats_have_current_lang \
      && title_matched \
      && description_has_current_lang \
      && description_has_patterns
  end
  percentage = matched.to_f / (total / 100.0)

  puts OUTPUT_FORMAT % [percentage, matched, total]
end
