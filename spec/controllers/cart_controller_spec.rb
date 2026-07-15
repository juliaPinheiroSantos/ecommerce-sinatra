require 'spec_helper'

RSpec.describe CartController, type: :controller do
  let(:cliente) { User.create!(nome: "C", email: "c@e.com", password: "123", tipo: "cliente", cpf: "111.111.111-11") }
  let(:vendedor) { User.create!(nome: "V", email: "v@e.com", password: "123", tipo: "vendedor", cpf: "000.000.000-00") }
  let(:produto) { Product.create!(nome: "Torta", preco: 10, estoque: 10, vendedor: vendedor) }

  it "adiciona item ao carrinho na sessão" do
    post '/login', { email: cliente.email, password: "123" }
    post '/carrinho/adicionar', { produto_id: produto.id, quantidade: 1 }
    
    expect(last_response).to be_redirect
    expect(last_request.env['rack.session'][:cart]).to eq({ produto.id => 1 })
  end
end