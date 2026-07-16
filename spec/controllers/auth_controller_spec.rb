require 'spec_helper'

RSpec.describe AuthController, type: :controller do
  describe "GET /cadastro" do
    it "responde com sucesso" do
      get '/cadastro'
      expect(last_response.status).to eq(200)
    end
  end

  describe "POST /cadastro" do
    it "cria um novo usuário, autentica e redireciona quando os dados são válidos" do
      expect {
        post '/cadastro', { nome: "Ana", email: "ana@teste.com", cpf: "111.111.111-11", password: "123456" }
      }.to change(User, :count).by(1)

      expect(last_response).to be_redirect
      expect(last_request.env['rack.session'][:user_id]).to eq(User.last.id)
    end

    it "não cria usuário e reexibe o formulário quando os dados são inválidos" do
      expect {
        post '/cadastro', { nome: "", email: "invalido", cpf: "", password: "123456" }
      }.to_not change(User, :count)

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Ops! Verifique os erros")
    end
  end

  describe "GET /login" do
    it "responde com sucesso quando não está logado" do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it "redireciona para a home quando já está logado" do
      User.create!(nome: "Ana", email: "ana@teste.com", password: "123456", cpf: "111.111.111-11")
      post '/login', { email: "ana@teste.com", password: "123456" }

      get '/login'
      expect(last_response).to be_redirect
    end
  end

  describe "POST /login" do
    let!(:usuario) { User.create!(nome: "Ana", email: "ana@teste.com", password: "123456", cpf: "111.111.111-11") }

    it "autentica e redireciona com credenciais válidas" do
      post '/login', { email: "ana@teste.com", password: "123456" }

      expect(last_response).to be_redirect
      expect(last_request.env['rack.session'][:user_id]).to eq(usuario.id)
    end

    it "não autentica com senha inválida" do
      post '/login', { email: "ana@teste.com", password: "senha_errada" }

      expect(last_response.status).to eq(200)
      expect(last_request.env['rack.session'][:user_id]).to be_nil
    end
  end

  describe "GET /logout" do
    it "encerra a sessão e redireciona para o login" do
      User.create!(nome: "Ana", email: "ana@teste.com", password: "123456", cpf: "111.111.111-11")
      post '/login', { email: "ana@teste.com", password: "123456" }

      get '/logout'

      expect(last_response).to be_redirect
      expect(last_request.env['rack.session'][:user_id]).to be_nil
    end
  end
end
