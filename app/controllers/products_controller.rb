class ProductsController < ApplicationController
  helpers AuthHelper
  helpers ApplicationHelper
  helpers FlashHelper

  get '/produtos/novo' do
    require_vendedor!
    erb :'products/new', layout: :'layouts/application'
  end

  post '/produtos' do
    require_vendedor!
    
    @produto = Product.new(
      nome: params[:nome],
      descricao: params[:descricao],
      preco: params[:preco],
      estoque: params[:estoque],
      vendedor: current_user 
    )
    
    if @produto.save
      flash_message(:success, "Torta adicionada ao catálogo com sucesso!")
      redirect "/produtos/#{@produto.id}"
    else
      flash_message(:error, "Ops! Verifique os dados:<br>#{@produto.errors.full_messages.join('<br>')}")
      erb :'products/new', layout: :'layouts/application'
    end
  end

  get '/produtos' do
    @produtos = Product.all
    erb :'products/index', layout: :'layouts/application'
  end

  get '/produtos/:id' do
    @produto = Product.find_by(id: params[:id])
    
    if @produto
      erb :'products/show', layout: :'layouts/application'
    else
      flash_message(:error, "O produto que você tentou acessar não existe.")
      redirect '/produtos'
    end
  end

  get '/produtos/:id/editar' do
    require_vendedor!
    @produto = Product.find_by(id: params[:id])
    
    if @produto.nil? || @produto.vendedor_id != current_user.id
      flash_message(:error, "Você não tem permissão para editar este produto.")
      redirect '/produtos'
    end
    
    erb :'products/edit', layout: :'layouts/application'
  end

  post '/produtos/:id' do
    require_login!
    @produto = Product.find_by(id: params[:id])
    
    if @produto.vendedor_id == current_user.id
      if @produto.update(
        nome: params[:nome], 
        descricao: params[:descricao], 
        preco: params[:preco], 
        estoque: params[:estoque]
      )
        flash_message(:success, "Produto atualizado com sucesso!")
        redirect "/produtos/#{@produto.id}"
      else
        flash_message(:error, "Erro ao atualizar:<br>#{@produto.errors.full_messages.join('<br>')}")
        erb :'products/edit', layout: :'layouts/application'
      end
    end
  end

  post '/produtos/:id/deletar' do
    require_vendedor!
    @produto = Product.find_by(id: params[:id])
    
    if @produto && @produto.vendedor_id == current_user.id
      @produto.destroy
      flash_message(:success, "Produto removido do catálogo.")
    end
    
    redirect '/produtos'
  end
end