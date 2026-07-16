class ProfileController < ApplicationController
  helpers AuthHelper

  get '/perfil' do
    require_login!
    erb :'profile/show', layout: :'layouts/application'
  end

  get '/perfil/editar' do
    require_login!
    erb :'profile/edit', layout: :'layouts/application'
  end

  post '/perfil/editar' do
    require_login!
    @user = current_user
    @user.nome = params[:nome]
    @user.telefone = params[:telefone]
    @user.cpf = params[:cpf]
    
    if params[:password] && !params[:password].strip.empty?
      @user.password = params[:password]
    end

    if @user.save
      flash_message(:success, "Perfil atualizado com sucesso!")
      redirect '/perfil'
    else
      @erros = @user.errors.full_messages
      erb :'profile/edit', layout: :'layouts/application'
    end
  end
end