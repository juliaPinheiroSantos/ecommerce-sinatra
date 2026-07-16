class AddTipoToUsuarios < ActiveRecord::Migration[8.1]
  def change
    add_column :usuarios, :tipo, :string, default: 'cliente'
  end
end
