require 'spec_helper'

RSpec.describe Product, type: :model do
  let(:vendedor) { User.create!(nome: "Loja", email: "loja@email.com", password: "123", cpf: "000.000.000-00") }
  subject { Product.new(nome: "Torta", preco: 10.0, estoque: 5, vendedor: vendedor) }

  describe "Validações" do
    it "é válido com atributos válidos" do
      expect(subject).to be_valid
    end

    it "é inválido sem nome" do
      subject.nome = nil
      expect(subject).to_not be_valid
    end

    it "é inválido com preço negativo" do
      subject.preco = -1
      expect(subject).to_not be_valid
    end
  end

  describe "Regras de Negócio (Estoque)" do
    it "deve debitar o estoque corretamente" do
      subject.save!
      subject.debitar_estoque!(2)
      expect(subject.reload.estoque).to eq(3)
    end

    it "deve lançar erro se tentar debitar mais do que tem" do
      subject.estoque = 1
      subject.save!
      expect { subject.debitar_estoque!(5) }.to raise_error(RuntimeError, /Estoque insuficiente/)
    end
  end
end