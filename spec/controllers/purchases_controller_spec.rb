require 'spec_helper'

RSpec.describe PurchasesController, type: :controller do
  let!(:vendedor) { User.create!(nome: "Loja", email: "loja@teste.com", password: "123456", cpf: "000.000.000-00") }
  let!(:comprador) { User.create!(nome: "Cliente", email: "cliente@teste.com", password: "123456", cpf: "111.111.111-11") }
  let!(:compra) { Sale.create!(vendedor: vendedor, comprador: comprador, status: 'pendente', data: Time.now, valor_total: 50.0) }

  describe "GET /compras" do
    it "redireciona para o login quando não está autenticado" do
      get '/compras'
      expect(last_response).to be_redirect
    end

    it "lista apenas as compras do usuário autenticado" do
      outro_comprador = User.create!(nome: "Outro Cliente", email: "outro@teste.com", password: "123456", cpf: "222.222.222-22")
      Sale.create!(vendedor: vendedor, comprador: outro_comprador, status: 'pendente', data: Time.now, valor_total: 20.0)

      post '/login', { email: comprador.email, password: "123456" }
      get '/compras'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("##{compra.id}")
    end
  end

  describe "GET /compras/:id" do
    it "mostra os detalhes da própria compra" do
      post '/login', { email: comprador.email, password: "123456" }
      get "/compras/#{compra.id}"

      expect(last_response.status).to eq(200)
    end

    it "redireciona quando a compra não pertence ao usuário autenticado" do
      outro_comprador = User.create!(nome: "Outro Cliente", email: "outro2@teste.com", password: "123456", cpf: "333.333.333-33")
      post '/login', { email: outro_comprador.email, password: "123456" }

      get "/compras/#{compra.id}"

      expect(last_response).to be_redirect
    end
  end

  describe "POST /compras/:id/cancelar" do
    it "cancela a compra pendente e restaura o estoque no banco" do
      produto = Product.create!(nome: "Torta", preco: 25.0, estoque: 3, vendedor: vendedor)
      SaleItem.create!(venda: compra, produto: produto, quantidade: 2, preco_unitario: 25.0)

      post '/login', { email: comprador.email, password: "123456" }
      post "/compras/#{compra.id}/cancelar"

      expect(last_response).to be_redirect
      expect(compra.reload.status).to eq('cancelada')
      expect(produto.reload.estoque).to eq(5)
    end

    it "não permite cancelar uma compra que já foi paga" do
      compra.update!(status: 'paga')

      post '/login', { email: comprador.email, password: "123456" }
      post "/compras/#{compra.id}/cancelar"

      expect(compra.reload.status).to eq('paga')
    end
  end
end
