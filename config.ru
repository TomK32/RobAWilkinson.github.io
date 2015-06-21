require 'rack/jekyll'
require 'yaml'
require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'
class HTML < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet # yep, that's it.
end
run Rack::Jekyll.new
