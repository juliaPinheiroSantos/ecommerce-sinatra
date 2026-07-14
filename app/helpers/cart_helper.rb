module CartHelper
  def carrinho
    session[:cart] ||= {}
  end

  def itens_do_carrinho
    itens = {}
    carrinho.each do |produto_id, quantidade|
      produto = Product.find_by(id: produto_id)
      itens[produto] = quantidade if produto
    end
    itens
  end

  def total_do_carrinho
    itens_do_carrinho.sum { |produto, quantidade| produto.preco * quantidade }
  end

  def quantidade_itens_no_carrinho
    carrinho.values.sum
  end
end