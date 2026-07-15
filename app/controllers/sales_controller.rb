require_relative '../services/sale_status_service'

class SalesController < ApplicationController
  helpers AuthHelper
  helpers ApplicationHelper
  helpers FlashHelper

  get '/vendas' do
    require_vendedor!
    
    @vendas = current_user.vendas_como_vendedor.order(created_at: :desc)
    
    erb :'sales/index', layout: :'layouts/application'
  end

  post '/vendas/:id/avancar' do
    require_vendedor!
    venda = current_user.vendas_como_vendedor.find_by(id: params[:id])

    if venda
      begin
        SaleStatusService.new(venda).avancar!
        flash_message(:success, "Status do pedido ##{venda.id} atualizado com sucesso!")
      rescue => e
        flash_message(:error, "Atenção: #{e.message}")
      end
    else
      flash_message(:error, "Pedido não encontrado.")
    end
    
    redirect '/vendas'
  end

  post '/vendas/:id/cancelar' do
    require_vendedor!
    
    venda = current_user.vendas_como_vendedor.find_by(id: params[:id])

    if venda
      begin
        SaleStatusService.new(venda).cancelar!
        flash_message(:success, "O pedido ##{venda.id} foi cancelado e o estoque foi restaurado.")
      rescue => e
        flash_message(:error, "Atenção: #{e.message}")
      end
    end
    
    redirect '/vendas'
  end
end