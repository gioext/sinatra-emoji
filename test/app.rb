require 'rubygems'
require 'sinatra'
require '../lib/sinatra/emoji'

get '/' do
  erb :index
end

helpers do
  # use __erb__
  def partial(sym)
    __erb__ sym, :layout => false
  end
end

configure do
  # default
  set :output_encoding_sjis, true
end

__END__
@@ layout
<html>
  <head><title>test</title></head>
  <body>
  <%= yield %>
  </body>
</html>

@@ index
<%= emoji(0) %>
<%= partial(:parts) %>

@@parts
<%= emoji(1) %>
<br />
はろー
