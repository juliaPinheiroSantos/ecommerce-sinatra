require 'spec_helper'

RSpec.describe ProductsController, type: :controller do
  let(:vendedor) { User.create!(nome: "Loja", email: "l@e.com", password: "123", cpf: "000.000.000-00") }
  let(:outro_usuario) { User.create!(nome: "Outra Loja", email: "outra@e.com", password: "123", cpf: "999.999.999-99") }

  describe "GET /produtos/novo" do
    it "redireciona para o login quando não está autenticado" do
      get '/produtos/novo'
      expect(last_response).to be_redirect
    end

    it "responde com sucesso quando autenticado" do
      post '/login', { email: vendedor.email, password: "123" }
      get '/produtos/novo'
      expect(last_response.status).to eq(200)
    end
  end

  describe "GET /produtos" do
    it "responde com sucesso" do
      post '/login', { email: vendedor.email, password: "123" }
      get '/produtos'
      expect(last_response.status).to eq(200)
    end

    it "filtra os produtos pelo termo de busca" do
      Product.create!(nome: "Torta de Morango", preco: 10.0, estoque: 5, vendedor: vendedor)
      Product.create!(nome: "Torta de Chocolate", preco: 12.0, estoque: 5, vendedor: vendedor)

      get '/produtos', { busca: "Morango" }

      expect(last_response.body).to include("Torta de Morango")
      expect(last_response.body).to_not include("Torta de Chocolate")
    end
  end

  describe "GET /produtos/meus" do
    it "redireciona para o login quando não está autenticado" do
      get '/produtos/meus'
      expect(last_response).to be_redirect
    end

    it "lista apenas os produtos do usuário autenticado" do
      Product.create!(nome: "Torta do Vendedor", preco: 10.0, estoque: 5, vendedor: vendedor)
      Product.create!(nome: "Torta de Outra Loja", preco: 10.0, estoque: 5, vendedor: outro_usuario)

      post '/login', { email: vendedor.email, password: "123" }
      get '/produtos/meus'

      expect(last_response.body).to include("Torta do Vendedor")
      expect(last_response.body).to_not include("Torta de Outra Loja")
    end
  end

  describe "GET /produtos/:id" do
    it "responde com sucesso quando o produto existe" do
      produto = Product.create!(nome: "Torta", preco: 10.0, estoque: 5, vendedor: vendedor)
      get "/produtos/#{produto.id}"
      expect(last_response.status).to eq(200)
    end

    it "redireciona quando o produto não existe" do
      get "/produtos/99999"
      expect(last_response).to be_redirect
    end
  end

  describe "POST /produtos" do
    it "redireciona para o login quando não está autenticado" do
      expect {
        post '/produtos', { nome: "Torta Teste", preco: 10.0, estoque: 5 }
      }.to_not change(Product, :count)

      expect(last_response).to be_redirect
    end

    it "cria um novo produto no banco quando logado" do
      post '/login', { email: vendedor.email, password: "123" }

      expect {
        post '/produtos', { nome: "Torta Teste", preco: 10.0, estoque: 5 }
      }.to change(Product, :count).by(1)

      expect(last_response).to be_redirect
      expect(Product.last.vendedor_id).to eq(vendedor.id)
    end

    it "não cria o produto quando os dados são inválidos" do
      post '/login', { email: vendedor.email, password: "123" }

      expect {
        post '/produtos', { nome: "", preco: -1, estoque: 5 }
      }.to_not change(Product, :count)

      expect(last_response.status).to eq(200)
    end
  end

  describe "POST /produtos/:id" do
    it "atualiza o produto no banco quando pertence ao usuário autenticado" do
      produto = Product.create!(nome: "Torta", preco: 10.0, estoque: 5, vendedor: vendedor)
      post '/login', { email: vendedor.email, password: "123" }

      post "/produtos/#{produto.id}", { nome: "Torta Atualizada", descricao: "", preco: 15.0, estoque: 8 }

      expect(last_response).to be_redirect
      expect(produto.reload.nome).to eq("Torta Atualizada")
    end

    it "não atualiza e redireciona quando o produto não existe" do
      post '/login', { email: vendedor.email, password: "123" }
      post "/produtos/99999", { nome: "X", preco: 1.0, estoque: 1 }

      expect(last_response).to be_redirect
    end

    it "não atualiza quando o produto pertence a outro usuário" do
      produto = Product.create!(nome: "Torta", preco: 10.0, estoque: 5, vendedor: outro_usuario)
      post '/login', { email: vendedor.email, password: "123" }

      post "/produtos/#{produto.id}", { nome: "Torta Hackeada", descricao: "", preco: 1.0, estoque: 1 }

      expect(last_response).to be_redirect
      expect(produto.reload.nome).to eq("Torta")
    end
  end

  describe "POST /produtos/:id/deletar" do
    it "remove o produto do banco quando pertence ao usuário autenticado" do
      produto = Product.create!(nome: "Torta", preco: 10.0, estoque: 5, vendedor: vendedor)
      post '/login', { email: vendedor.email, password: "123" }

      expect {
        post "/produtos/#{produto.id}/deletar"
      }.to change(Product, :count).by(-1)

      expect(last_response).to be_redirect
    end

    it "não remove o produto quando pertence a outro usuário" do
      produto = Product.create!(nome: "Torta", preco: 10.0, estoque: 5, vendedor: outro_usuario)
      post '/login', { email: vendedor.email, password: "123" }

      expect {
        post "/produtos/#{produto.id}/deletar"
      }.to_not change(Product, :count)
    end
  end
end
