class User < ActiveRecord::Base
  self.table_name = "usuarios"

  has_secure_password :password, validations: true
  alias_attribute :password_digest, :senha_hash
  
  has_many :produtos, foreign_key: :vendedor_id, class_name: 'Product', dependent: :destroy
  has_many :vendas_como_vendedor, foreign_key: :vendedor_id, class_name: 'Sale', dependent: :destroy
  has_many :compras_como_comprador, foreign_key: :comprador_id, class_name: 'Sale', dependent: :destroy

  def vendedor?
    self.tipo == 'vendedor'
  end

  def cliente?
    self.tipo == 'cliente'
  end

  validates :nome, presence: true 
  validates :cpf, presence: true 
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false }, 
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "formato de e-mail inválido" }
end