require 'spec_helper'

RSpec.describe ProductsController, type: :controller do
  let(:vendedor) { User.create!(nome: "Loja", email: "l@e.com", password: "123", tipo: "vendedor", cpf: "000.000.000-00") }

  describe "GET /produtos" do
    it "responde com sucesso" do
      post '/login', { email: vendedor.email, password: "123" }
      get '/produtos'
      puts last_response.location
      expect(last_response.status).to eq(200)
    end
  end

  describe "POST /produtos" do
    it "cria um novo produto quando logado" do
      post '/login', { email: vendedor.email, password: "123" }
      
      expect {
        post '/produtos', { nome: "Torta Teste", preco: 10.0, estoque: 5 }
      }.to change(Product, :count).by(1)
      
      expect(last_response).to be_redirect
    end
  end
end