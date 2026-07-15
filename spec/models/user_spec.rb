require 'spec_helper'

RSpec.describe User, type: :model do
  subject { User.new(nome: "Teste", email: "teste@teste.com", password: "123", tipo: "cliente", cpf: "222.222.222-22") }

  describe "Validações Básicas" do
    it "é válido com dados completos" do
      expect(subject).to be_valid
    end

    it "é inválido sem email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end
  end

  describe "Métodos de Tipo" do
    it "identifica corretamente se é cliente ou vendedor" do
      expect(subject.cliente?).to be(true)
      
      subject.tipo = 'vendedor'
      expect(subject.vendedor?).to be(true)
    end
  end
end