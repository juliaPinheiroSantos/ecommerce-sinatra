class ProductsController < ApplicationController
  helpers AuthHelper
  helpers ApplicationHelper

  get '/produtos' do
    @produtos = Product.all
    erb :'products/index', layout: :'layouts/application'
  end

  get '/produtos/:id' do
    @produto = Product.find_by(id: params[:id])
    
    if @produto
      erb :'products/show', layout: :'layouts/application'
    else
      flash_message(:error, "O produto que você tentou acessar não existe ou foi removido.")
      redirect '/produtos'
    end
  end
end