require 'spec_helper'

RSpec.describe User, type: :model do
  subject { User.new(nome: "Teste", email: "teste@teste.com", password: "123", cpf: "222.222.222-22") }

  describe "Validações Básicas" do
    it "é válido com dados completos" do
      expect(subject).to be_valid
    end

    it "é inválido sem email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "é inválido sem cpf" do
      subject.cpf = nil
      expect(subject).to_not be_valid
    end

    it "é inválido com email em formato inválido" do
      subject.email = "email-invalido"
      expect(subject).to_not be_valid
    end

    it "é inválido com email duplicado (case insensitive)" do
      User.create!(nome: "Outro", email: "TESTE@teste.com", password: "123", cpf: "111.111.111-11")
      expect(subject).to_not be_valid
    end
  end

  describe "Associações" do
    it "possui muitos produtos, vendas como vendedor e compras como comprador" do
      assoc = User.reflect_on_all_associations.map(&:name)
      expect(assoc).to include(:produtos, :vendas_como_vendedor, :compras_como_comprador)
    end

    it "lista os produtos cadastrados pelo usuário" do
      usuario = User.create!(nome: "Loja", email: "loja@teste.com", password: "123", cpf: "333.333.333-33")
      Product.create!(nome: "Torta", preco: 10.0, estoque: 5, vendedor: usuario)

      expect(usuario.produtos.count).to eq(1)
    end
  end

  describe "Papel inferido por associações" do
    it "não é vendedor nem comprador quando ainda não cadastrou produtos ou compras" do
      usuario = User.create!(nome: "Novo", email: "novo@teste.com", password: "123", cpf: "444.444.444-44")

      expect(usuario.vendedor?).to be(false)
      expect(usuario.cliente?).to be(false)
    end

    it "passa a ser vendedor assim que cadastra um produto" do
      usuario = User.create!(nome: "Loja", email: "loja2@teste.com", password: "123", cpf: "555.555.555-55")
      Product.create!(nome: "Torta", preco: 10.0, estoque: 5, vendedor: usuario)

      expect(usuario.vendedor?).to be(true)
    end

    it "passa a ser comprador assim que realiza uma compra" do
      vendedor = User.create!(nome: "Loja", email: "loja3@teste.com", password: "123", cpf: "666.666.666-66")
      comprador = User.create!(nome: "Comprador", email: "comprador@teste.com", password: "123", cpf: "777.777.777-77")
      Sale.create!(comprador: comprador, vendedor: vendedor, status: 'pendente', data: Time.now)

      expect(comprador.cliente?).to be(true)
    end

    it "o mesmo usuário pode ser vendedor e comprador ao mesmo tempo" do
      outro_vendedor = User.create!(nome: "Outra Loja", email: "outraloja@teste.com", password: "123", cpf: "888.888.888-88")
      usuario = User.create!(nome: "Multi", email: "multi@teste.com", password: "123", cpf: "999.999.999-99")

      Product.create!(nome: "Torta", preco: 10.0, estoque: 5, vendedor: usuario)
      Sale.create!(comprador: usuario, vendedor: outro_vendedor, status: 'pendente', data: Time.now)

      expect(usuario.vendedor?).to be(true)
      expect(usuario.cliente?).to be(true)
    end
  end
end
