require './config/environment'

class EcommerceApp < Sinatra::Base
  
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, 'app', 'views') }
  
  use ApplicationController
end