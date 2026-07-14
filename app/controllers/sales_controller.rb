class SalesController < ApplicationController
  helpers AuthHelper
  helpers ApplicationHelper
  helpers FlashHelper

  get '/vendas' do
    require_login!
    
    @vendas = current_user.vendas_como_vendedor.order(created_at: :desc)
    
    erb :'sales/index', layout: :'layouts/application'
  end
end