require 'spec_helper'

RSpec.describe ProfileController, type: :controller do
  let!(:usuario) { User.create!(nome: "Ana", email: "ana@teste.com", password: "123456", cpf: "111.111.111-11") }

  describe "GET /perfil" do
    it "redireciona para o login quando não está autenticado" do
      get '/perfil'
      expect(last_response).to be_redirect
    end

    it "responde com sucesso quando autenticado" do
      post '/login', { email: usuario.email, password: "123456" }
      get '/perfil'
      expect(last_response.status).to eq(200)
    end
  end

  describe "GET /perfil/editar" do
    it "redireciona para o login quando não está autenticado" do
      get '/perfil/editar'
      expect(last_response).to be_redirect
    end
  end

  describe "POST /perfil/editar" do
    it "atualiza os dados do usuário no banco e redireciona" do
      post '/login', { email: usuario.email, password: "123456" }

      post '/perfil/editar', { nome: "Ana Atualizada", telefone: "62999990000", cpf: usuario.cpf }

      expect(last_response).to be_redirect
      expect(usuario.reload.nome).to eq("Ana Atualizada")
      expect(usuario.telefone).to eq("62999990000")
    end

    it "não atualiza e reexibe o formulário quando os dados são inválidos" do
      post '/login', { email: usuario.email, password: "123456" }

      post '/perfil/editar', { nome: "", telefone: "", cpf: "" }

      expect(last_response.status).to eq(200)
      expect(usuario.reload.nome).to eq("Ana")
    end
  end
end
