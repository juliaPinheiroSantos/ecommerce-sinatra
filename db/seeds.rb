puts "Limpando o banco de dados antes de popular"
ActiveRecord::Base.connection.execute("DELETE FROM itens_venda")
ActiveRecord::Base.connection.execute("DELETE FROM vendas")
ActiveRecord::Base.connection.execute("DELETE FROM produtos")
ActiveRecord::Base.connection.execute("DELETE FROM usuarios")

puts "Criando Seed de Usuários"
vendedor_id = ActiveRecord::Base.connection.insert("
  INSERT INTO usuarios (nome, email, senha_hash, cpf, telefone, created_at, updated_at)
  VALUES ('Thalita Confeitaria', 'contato@docurasdathalita.com.br', 'senha_criptografada_123', '12345678901', '62988887777', datetime('now'), datetime('now'))
")

comprador_id = ActiveRecord::Base.connection.insert("
  INSERT INTO usuarios (nome, email, senha_hash, cpf, telefone, created_at, updated_at)
  VALUES ('João Silva', 'joao.silva@email.com', 'senha_criptografada_456', '98765432100', '62999998888', datetime('now'), datetime('now'))
")

puts "Criando Seed de Produtos"
torta_pequena_id = ActiveRecord::Base.connection.insert("
  INSERT INTO produtos (nome, descricao, preco, estoque, vendedor_id, created_at, updated_at)
  VALUES ('Torta Pequena', 'Deliciosa torta artesanal decorada de tamanho pequeno (aproximadamente 1kg).', 60.00, 10, #{vendedor_id}, datetime('now'), datetime('now'))
")

torta_media_id = ActiveRecord::Base.connection.insert("
  INSERT INTO produtos (nome, descricao, preco, estoque, vendedor_id, created_at, updated_at)
  VALUES ('Torta Média', 'Torta artesanal decorada sabor tradicional de tamanho médio (aproximadamente 2kg).', 80.00, 5, #{vendedor_id}, datetime('now'), datetime('now'))
")

torta_grande_id = ActiveRecord::Base.connection.insert("
  INSERT INTO produtos (nome, descricao, preco, estoque, vendedor_id, created_at, updated_at)
  VALUES ('Torta Grande', 'Espetacular torta festiva para celebrações de tamanho grande (aproximadamente 3kg).', 100.00, 3, #{vendedor_id}, datetime('now'), datetime('now'))
")

puts "Criando Seed de Venda"
valor_venda = 140.00
venda_id = ActiveRecord::Base.connection.insert("
  INSERT INTO vendas (comprador_id, vendedor_id, status, valor_total, data, created_at, updated_at)
  VALUES (#{comprador_id}, #{vendedor_id}, 'pendente', #{valor_venda}, datetime('now'), datetime('now'), datetime('now'))
")

puts "Vinculando Itens à Venda"
ActiveRecord::Base.connection.insert("
  INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario, created_at, updated_at)
  VALUES (#{venda_id}, #{torta_pequena_id}, 1, 60.00, datetime('now'), datetime('now'))
")

ActiveRecord::Base.connection.insert("
  INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario, created_at, updated_at)
  VALUES (#{venda_id}, #{torta_media_id}, 1, 80.00, datetime('now'), datetime('now'))
")

puts "Banco de dados populado"