class CreateItensVenda < ActiveRecord::Migration[8.1]
  def change
    create_table :itens_venda do |t|
      t.references :venda, null: false, foreign_key: { to_table: :vendas }
      t.references :produto, null: false, foreign_key: { to_table: :produtos }

      t.integer :quantidade, null: false, default: 1
      t.decimal :preco_unitario, precision: 10, scale: 2, null: false

      t.timestamps

    end
  end
end
