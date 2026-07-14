module ApplicationHelper
  def formatar_moeda(valor)
    return "R$ 0,00" if valor.nil?
    "R$ #{sprintf('%.2f', valor).tr('.', ',')}"
  end

  def formatar_data(data)
    return "" if data.nil?
    data.strftime("%d/%m/%Y às %H:%M")
  end
  
  def traduzir_status(status)
    mapa_status = {
      'pendente' => 'Aguardando Pagamento',
      'paga' => 'Pagamento Confirmado',
      'enviada' => 'Saiu para Entrega',
      'entregue' => 'Pedido Entregue',
      'cancelada' => 'Cancelado'
    }
    mapa_status[status] || status.capitalize
  end
end