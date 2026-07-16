class RemoveTipoFromUsuarios < ActiveRecord::Migration[8.1]
  def change
    remove_column :usuarios, :tipo, :string, default: 'cliente'
  end
end
