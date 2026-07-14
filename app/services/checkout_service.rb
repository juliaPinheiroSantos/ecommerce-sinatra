class CheckoutService
  def initialize(comprador, itens_carrinho)
    @comprador = comprador
    @itens_carrinho = itens_carrinho # Espera receber o Hash { Produto => Quantidade }
  end

  def call
    ActiveRecord::Base.transaction do
      
      vendedor = @itens_carrinho.keys.first.vendedor

      venda = Sale.create!(
        comprador: @comprador,
        vendedor: vendedor,
        status: 'pendente',
        data: Time.now,
        valor_total: 0 
      )

      @itens_carrinho.each do |produto, quantidade|
        produto.debitar_estoque!(quantidade)

        SaleItem.create!(
          venda: venda,
          produto: produto,
          quantidade: quantidade,
          preco_unitario: produto.preco
        )
      end

      venda.calcular_total!
      
      venda
      end
    end
  end