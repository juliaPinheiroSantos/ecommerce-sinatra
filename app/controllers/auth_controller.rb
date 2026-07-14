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
      flash_message(:success, "Conta criada com sucesso! Bem-vindo(a), #{@user.nome}.")
      redirect '/'
    else
      erros_formatados = @user.errors.full_messages.join('<br>')
      flash_message(:error, "<strong>Ops! Verifique os erros:</strong><br>#{erros_formatados}")
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
      flash_message(:success, "Que bom te ver por aqui, #{user.nome}!")
      redirect '/'
    else
      flash_message(:error, "E-mail ou senha inválidos. Tente novamente.")
      erb :'auth/login', layout: :'layouts/application'
    end
  end

  get '/logout' do
    session.clear
    flash_message(:success, "Você saiu da sua conta. Até logo!")
    redirect '/login'
  end
end