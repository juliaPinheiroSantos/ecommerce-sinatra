class Product < ActiveRecord::Base
  self.table_name = "produtos"

  belongs_to :vendedor, class_name: 'User', foreign_key: :vendedor_id
  has_many :itens_venda, class_name: 'SaleItem', foreign_key: :produto_id

  validates :nome, presence: true 
  validates :preco, presence: true, numericality: { greater_than: 0 }
  validates :estoque, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def estoque_disponivel?(quantidade)
    self.estoque >= quantidade
  end

  def debitar_estoque!(quantidade)
    unless estoque_disponivel?(quantidade)
      raise "Estoque insuficiente para o produto #{self.nome}."
    end

    self.decrement!(:estoque, quantidade)
  end
end