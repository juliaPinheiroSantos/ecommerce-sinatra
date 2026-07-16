class SaleStatusService
  def initialize(venda)
    @venda = venda
  end

  def avancar!
    case @venda.status
    when 'pendente'
      @venda.update!(status: 'paga')
    when 'paga'
      @venda.update!(status: 'enviada')
    when 'enviada'
      @venda.update!(status: 'entregue')
    else
      raise "Não é possível avançar. O pedido já está #{@venda.status}."
    end
  end

  def cancelar!
    if ['pendente', 'paga'].include?(@venda.status)
      ActiveRecord::Base.transaction do
        @venda.update!(status: 'cancelada')
        
        itens = SaleItem.where(venda_id: @venda.id)
        
        itens.each do |item|
          item.produto.increment!(:estoque, item.quantidade)
        end
      end
    else
      raise "Pedidos enviados ou entregues não podem mais ser cancelados."
    end
  end
end