class Sale < ActiveRecord::Base
  self.table_name = "vendas"
  
  belongs_to :comprador, class_name: 'User', foreign_key: :comprador_id
  belongs_to :vendedor, class_name: 'User', foreign_key: :vendedor_id
  has_many :itens_venda, class_name: 'SaleItem', foreign_key: :venda_id, dependent: :destroy
  
  enum :status, {
    pendente: 'pendente',
    paga: 'paga',
    enviada: 'enviada',
    entregue: 'entregue',
    cancelada: 'cancelada'
  }

  validates :status, presence: true
  validates :valor_total, numericality: { greater_than_or_equal_to: 0 }
  validates :data, presence: true

  def calcular_total!
    total_calculado = self.itens_venda.sum { |item| item.quantidade * item.preco_unitario }
    self.update!(valor_total: total_calculado)
  end
end