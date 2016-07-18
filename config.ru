begin
  require 'rack-livereload'
  use Rack::LiveReload if defined? Rack::LiveReload
rescue LoadError
end

require './app'
run Sinatra::Application
