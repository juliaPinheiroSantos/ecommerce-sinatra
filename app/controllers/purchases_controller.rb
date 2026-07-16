require_relative '../services/sale_status_service'

class PurchasesController < ApplicationController
  helpers AuthHelper
  helpers ApplicationHelper
  helpers FlashHelper

  get '/compras' do
    require_login!
    
    @compras = Sale.where(comprador_id: current_user.id).order(created_at: :desc)
    
    erb :'purchases/index', layout: :'layouts/application'
  end

  get '/compras/:id' do
    require_login!
    
    @compra = Sale.find_by(id: params[:id], comprador_id: current_user.id)
    
    if @compra
      @itens = SaleItem.where(venda_id: @compra.id)
      erb :'purchases/show', layout: :'layouts/application'
    else
      flash_message(:error, "Pedido não encontrado.")
      redirect '/compras'
    end
  end

  post '/compras/:id/cancelar' do
    require_login!

    @compra = Sale.find_by(id: params[:id], comprador_id: current_user.id)

    if @compra.nil?
      flash_message(:error, "Pedido não encontrado.")
    elsif @compra.status != 'pendente'
      flash_message(:error, "Só é possível cancelar pedidos que ainda estão pendentes.")
    else
      begin
        ::SaleStatusService.new(@compra).cancelar!
        flash_message(:success, "Sua compra ##{@compra.id} foi cancelada. O vendedor foi notificado.")
      rescue => e
        flash_message(:error, "Não foi possível cancelar: #{e.message}")
      end
    end

    redirect '/compras'
  end
end