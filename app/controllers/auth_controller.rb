class AuthController < ApplicationController
  helpers AuthHelper

  get '/cadastro' do
    erb :'auth/register', layout: :'layouts/application'
  end

  post '/cadastro' do
    @user = User.new(
      nome: params[:nome],
      email: params[:email],
      cpf: params[:cpf],
      telefone: params[:telefone],
      password: params[:password]
    )

    if @user.save
      session[:user_id] = @user.id
      redirect '/'
    else
      @erros = @user.errors.full_messages
      erb :'auth/register', layout: :'layouts/application'
    end
  end

  get '/login' do
    redirect '/' if logged_in?
    erb :'auth/login', layout: :'layouts/application'
  end

  post '/login' do
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/'
    else
      @erro = "E-mail ou senha inválidos."
      erb :'auth/login', layout: :'layouts/application'
    end
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end
end