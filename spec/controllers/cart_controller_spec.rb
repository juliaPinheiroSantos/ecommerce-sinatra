require 'spec_helper'

RSpec.describe CartController, type: :controller do
  let(:cliente) { User.create!(nome: "C", email: "c@e.com", password: "123", cpf: "111.111.111-11") }
  let(:vendedor) { User.create!(nome: "V", email: "v@e.com", password: "123", cpf: "000.000.000-00") }
  let(:produto) { Product.create!(nome: "Torta", preco: 10, estoque: 10, vendedor: vendedor) }

  describe "GET /carrinho" do
    it "redireciona para o login quando não está autenticado" do
      get '/carrinho'
      expect(last_response).to be_redirect
    end
  end

  describe "POST /carrinho/adicionar" do
    it "adiciona item ao carrinho na sessão" do
      post '/login', { email: cliente.email, password: "123" }
      post '/carrinho/adicionar', { produto_id: produto.id, quantidade: 1 }

      expect(last_response).to be_redirect
      expect(last_request.env['rack.session'][:cart]).to eq({ produto.id => 1 })
    end

    it "não adiciona quando o estoque é insuficiente" do
      post '/login', { email: cliente.email, password: "123" }
      post '/carrinho/adicionar', { produto_id: produto.id, quantidade: 999 }

      expect(last_response).to be_redirect
      expect(last_request.env['rack.session'][:cart]).to be_nil
    end
  end

  describe "POST /carrinho/remover" do
    it "remove o item do carrinho na sessão" do
      post '/login', { email: cliente.email, password: "123" }
      post '/carrinho/adicionar', { produto_id: produto.id, quantidade: 1 }

      post '/carrinho/remover', { produto_id: produto.id }

      expect(last_response).to be_redirect
      expect(last_request.env['rack.session'][:cart]).to eq({})
    end
  end

  describe "POST /checkout" do
    it "cria a venda e os itens no banco, debita o estoque e limpa o carrinho" do
      post '/login', { email: cliente.email, password: "123" }
      post '/carrinho/adicionar', { produto_id: produto.id, quantidade: 2 }

      expect {
        post '/checkout'
      }.to change(Sale, :count).by(1).and change(SaleItem, :count).by(1)

      expect(last_response).to be_redirect
      expect(produto.reload.estoque).to eq(8)
      expect(Sale.last.valor_total).to eq(20.0)
      expect(last_request.env['rack.session'][:cart]).to be_nil
    end

    it "não cria venda quando o carrinho está vazio" do
      post '/login', { email: cliente.email, password: "123" }

      expect {
        post '/checkout'
      }.to_not change(Sale, :count)

      expect(last_response).to be_redirect
    end
  end
end
