class SaleItem < ActiveRecord::Base
  self.table_name = "itens_venda"

  belongs_to :venda, class_name: 'Sale', foreign_key: :venda_id
  belongs_to :produto, class_name: 'Product', foreign_key: :produto_id

  validates :quantidade, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :preco_unitario, presence: true, numericality: { greater_than_or_equal_to: 0 }
end