require 'spec_helper'

RSpec.describe Sale, type: :model do
  let(:vendedor) { User.create!(nome: "V", email: "v@e.com", password: "123", tipo: "vendedor", cpf: "000.000.000-00") }
  let(:comprador) { User.create!(nome: "C", email: "c@e.com", password: "123", tipo: "cliente", cpf: "111.111.111-11") }
  let(:venda) { Sale.new(vendedor: vendedor, comprador: comprador, status: 'pendente', data: Time.now) }

  it "deve pertencer a um vendedor e um comprador" do
    expect(venda.vendedor.nome).to eq("V")
    expect(venda.comprador.nome).to eq("C")
  end
  
  it "começa com status pendente por padrão" do
    venda = Sale.create!(
      vendedor: vendedor, 
      comprador: comprador, 
      data: Time.now
    )
    expect(venda.status).to eq('pendente')
  end
end