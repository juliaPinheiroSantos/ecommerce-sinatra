require 'spec_helper'

RSpec.describe SalesController, type: :controller do
  let!(:vendedor) { User.create!(nome: "Loja", email: "loja@teste.com", password: "123456", cpf: "000.000.000-00") }
  let!(:comprador) { User.create!(nome: "Cliente", email: "cliente@teste.com", password: "123456", cpf: "111.111.111-11") }
  let!(:venda) { Sale.create!(vendedor: vendedor, comprador: comprador, status: 'pendente', data: Time.now, valor_total: 50.0) }

  describe "GET /vendas" do
    it "redireciona para o login quando não está autenticado" do
      get '/vendas'
      expect(last_response).to be_redirect
    end

    it "lista apenas as vendas do vendedor autenticado" do
      outro_vendedor = User.create!(nome: "Outra Loja", email: "outra@teste.com", password: "123456", cpf: "222.222.222-22")
      Sale.create!(vendedor: outro_vendedor, comprador: comprador, status: 'pendente', data: Time.now, valor_total: 20.0)

      post '/login', { email: vendedor.email, password: "123456" }
      get '/vendas'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("##{venda.id}")
    end
  end

  describe "POST /vendas/:id/avancar" do
    it "avança o status da própria venda no banco de dados" do
      post '/login', { email: vendedor.email, password: "123456" }
      post "/vendas/#{venda.id}/avancar"

      expect(last_response).to be_redirect
      expect(venda.reload.status).to eq('paga')
    end

    it "não altera uma venda de outro vendedor" do
      outro_vendedor = User.create!(nome: "Outra Loja", email: "outra2@teste.com", password: "123456", cpf: "333.333.333-33")
      post '/login', { email: outro_vendedor.email, password: "123456" }

      post "/vendas/#{venda.id}/avancar"

      expect(venda.reload.status).to eq('pendente')
    end
  end

  describe "POST /vendas/:id/cancelar" do
    it "cancela a venda e restaura o estoque do produto no banco" do
      produto = Product.create!(nome: "Torta", preco: 25.0, estoque: 3, vendedor: vendedor)
      SaleItem.create!(venda: venda, produto: produto, quantidade: 2, preco_unitario: 25.0)

      post '/login', { email: vendedor.email, password: "123456" }
      post "/vendas/#{venda.id}/cancelar"

      expect(last_response).to be_redirect
      expect(venda.reload.status).to eq('cancelada')
      expect(produto.reload.estoque).to eq(5)
    end
  end
end
