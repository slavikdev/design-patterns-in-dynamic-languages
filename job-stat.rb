require 'rss'
require 'cgi'

RE_FIND = /design\spattern/i
LANGS = %w[Ruby JavaScript Python C# Java C++].freeze
OUTPUT_FORMAT = '%.2f %% (%d/%d)'.freeze

LANGS.each do |lang|
  print "#{lang}: "

  tag = CGI.escapeHTML(lang.downcase)
  url = "https://stackoverflow.com/jobs/feed?q=#{tag}"
  rss = RSS::Parser.parse(url, false)

  total = rss.items.size
  matched = rss.items.count do |item|
    has_design_patterns = CGI.unescapeHTML(item.description) =~ RE_FIND
    has_other_langs = LANGS.reject { |l| l == lang }.any? do |l|
      item.category && item.category.content.downcase.include?(l)
    end
    has_design_patterns && !has_other_langs
  end
  percentage = matched.to_f / (total / 100.0)

  puts OUTPUT_FORMAT % [percentage, matched, total]
end
