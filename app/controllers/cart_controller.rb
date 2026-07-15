class CartController < ApplicationController
  helpers CartHelper
  helpers AuthHelper
  helpers FlashHelper
  helpers ApplicationHelper

  get '/carrinho' do
    require_cliente!
    @itens = itens_do_carrinho
    @total = total_do_carrinho
    erb :'cart/show', layout: :'layouts/application'
  end

  post '/carrinho/adicionar' do
    require_cliente!
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
    require_cliente!
    produto_id = params[:produto_id].to_i
    carrinho.delete(produto_id)
    
    flash_message(:success, "Produto removido do carrinho.")
    redirect '/carrinho'
  end

  post '/checkout' do
    require_cliente!
    
    if carrinho.empty?
      flash_message(:error, "Seu carrinho está vazio. Adicione algumas tortas primeiro!")
      redirect '/produtos'
    end

    begin
      servico = CheckoutService.new(current_user, itens_do_carrinho)
      venda = servico.call
      
      session.delete(:cart)
      
      flash_message(:success, "Pedido ##{venda.id} realizado com sucesso! Total: #{formatar_moeda(venda.valor_total)}")
      redirect '/perfil' 
      
    rescue => e
      flash_message(:error, "Erro ao processar o pedido: #{e.message}")
      redirect '/carrinho'
    end
  end
end