require "sinatra"
require "sinatra/activerecord"
require "sinatra/flash"

enable :sessions

get "/" do
  erb :vitrine
end

get "/login" do
  erb :login
end

get "/cadastro" do
  erb :cadastro
end

post '/cadastro' do
  
  flash[:notice] = "Os dados foram enviados com sucesso!"
  
  redirect '/'
end

post '/login' do
 
  session[:usuario_id] = 1 
  flash[:notice] = "Login realizado com sucesso!"
  redirect '/'
end

get '/logout' do
  session.clear
  flash[:notice] = "Você saiu da sua conta."
  redirect '/'
end

get '/perfil' do
  if session[:usuario_id]
    erb :perfil
  else
    flash[:error] = "Você precisa fazer login primeiro."
    redirect '/login'
  end
end