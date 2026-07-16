require 'spec_helper'

RSpec.describe SaleItem, type: :model do
  let(:vendedor) { User.create!(nome: "Loja", email: "loja@teste.com", password: "123", cpf: "000.000.000-00") }
  let(:comprador) { User.create!(nome: "Cliente", email: "cliente@teste.com", password: "123", cpf: "111.111.111-11") }
  let(:venda) { Sale.create!(vendedor: vendedor, comprador: comprador, status: 'pendente', data: Time.now) }
  let(:produto) { Product.create!(nome: "Torta", preco: 20.0, estoque: 10, vendedor: vendedor) }

  subject { SaleItem.new(venda: venda, produto: produto, quantidade: 2, preco_unitario: 20.0) }

  describe "Associações" do
    it "pertence a uma venda e a um produto" do
      subject.save!
      expect(subject.venda).to eq(venda)
      expect(subject.produto).to eq(produto)
    end
  end

  describe "Validações" do
    it "é válido com atributos válidos" do
      expect(subject).to be_valid
    end

    it "é inválido sem quantidade" do
      subject.quantidade = nil
      expect(subject).to_not be_valid
    end

    it "é inválido com quantidade igual a zero" do
      subject.quantidade = 0
      expect(subject).to_not be_valid
    end

    it "é inválido com quantidade negativa" do
      subject.quantidade = -1
      expect(subject).to_not be_valid
    end

    it "é inválido sem preço unitário" do
      subject.preco_unitario = nil
      expect(subject).to_not be_valid
    end

    it "é inválido com preço unitário negativo" do
      subject.preco_unitario = -1
      expect(subject).to_not be_valid
    end
  end

  describe "Regra de Negócio" do
    it "guarda o preço unitário praticado no momento da compra, independente de mudanças futuras no produto" do
      subject.save!
      produto.update!(preco: 99.0)

      expect(subject.reload.preco_unitario).to eq(20.0)
    end
  end
end
