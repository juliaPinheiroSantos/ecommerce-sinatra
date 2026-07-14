class CartController < ApplicationController
  helpers CartHelper
  helpers AuthHelper
  helpers FlashHelper
  helpers ApplicationHelper

  get '/carrinho' do
    @itens = itens_do_carrinho
    @total = total_do_carrinho
    erb :'cart/show', layout: :'layouts/application'
  end

  post '/carrinho/adicionar' do
    produto_id = params[:produto_id].to_i
    quantidade = params[:quantidade].to_i
    quantidade = 1 if quantidade <= 0

    produto = Product.find_by(id: produto_id)

    if produto.nil?
      flash_message(:error, "O produto selecionado não foi encontrado.")
      redirect '/produtos'
    elsif !produto.estoque_disponivel?(quantidade)
      flash_message(:error, "Ops! Estoque insuficiente. Temos apenas #{produto.estoque} unidades disponíveis.")
      redirect "/produtos/#{produto.id}"
    else
      carrinho[produto_id] ||= 0
      nova_quantidade = carrinho[produto_id] + quantidade

      if produto.estoque_disponivel?(nova_quantidade)
        carrinho[produto_id] = nova_quantidade
        flash_message(:success, "Delícia! '#{produto.nome}' foi adicionado ao seu carrinho.")
        redirect '/carrinho'
      else
        flash_message(:error, "Você já adicionou a quantidade limite de estoque deste produto ao seu carrinho.")
        redirect "/produtos/#{produto.id}"
      end
    end
  end

  post '/carrinho/remover' do
    produto_id = params[:produto_id].to_i
    carrinho.delete(produto_id)
    
    flash_message(:success, "Produto removido do carrinho.")
    redirect '/carrinho'
  end
end