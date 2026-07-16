require 'spec_helper'

RSpec.describe "Fluxo Completo da Confeitaria", type: :feature do
  let!(:vendedor) { User.create!(nome: "Thalita", email: "thalita@doces.com", password: "senha123", cpf: "000.000.000-00") }

  context "Como Vendedor" do
    let!(:cliente_comprador) { User.create!(nome: "Cliente Comprador", email: "comprador@teste.com", password: "senha456", cpf: "222.222.222-22") }

    before do
      visit '/login'
      fill_in 'email', with: vendedor.email
      fill_in 'senha', with: 'senha123'
      click_button 'Acessar Conta'
    end

    it "publica produto, recebe pedido de um cliente e avança o status do pedido até a entrega" do
      visit '/produtos'
      find("a[href='/produtos/novo']").click
      fill_in 'nome', with: 'Torta de Morango'
      fill_in 'descricao', with: 'Torta deliciosa'
      fill_in 'preco', with: '50.00'
      fill_in 'estoque', with: '10'
      click_button 'Adicionar ao Catálogo'

      expect(page).to have_content('Torta de Morango')

      Capybara.using_session(:cliente_comprador) do
        visit '/login'
        fill_in 'email', with: cliente_comprador.email
        fill_in 'senha', with: 'senha456'
        click_button 'Acessar Conta'

        visit '/produtos'
        click_link 'Ver Detalhes'

        within("form[action='/carrinho/adicionar']") do
          fill_in 'quantidade', with: '1'
          click_button 'Adicionar ao Carrinho'
        end

        visit '/carrinho'
        click_button 'Finalizar Pedido'

        expect(page).to have_content('realizado com sucesso')
      end

      click_link 'Gestão de Pedidos'

      click_button 'Avançar'
      expect(page).to have_content('Pagamento Confirmado')

      click_button 'Avançar'
      expect(page).to have_content('Saiu para Entrega')

      click_button 'Avançar'
      expect(page).to have_content('Pedido Entregue')

      expect(page).to_not have_button('Avançar')
    end
  end

  context "Como Cliente" do
    let!(:vendedor_db) { User.create!(nome: "Vendedor", email: "v@v.com", password: "senha456", cpf: "333.333.333-33") }
    let!(:produto) { Product.create!(nome: "Torta de Morango", preco: 50.0, estoque: 10, vendedor_id: vendedor_db.id) }

    before do
      visit '/cadastro'
      fill_in 'nome', with: 'Cliente Teste'
      fill_in 'email', with: 'cliente@teste.com'
      fill_in 'cpf', with: '111.111.111-11'
      fill_in 'senha', with: 'senha456'
      click_button 'Criar Conta'

      expect(page).to have_content('Conta criada com sucesso')
    end

    it "se cadastra, adiciona produto ao carrinho e finaliza o pedido" do
      visit '/produtos'
      click_link 'Ver Detalhes'

      within("form[action='/carrinho/adicionar']") do
        fill_in 'quantidade', with: '1'
        click_button 'Adicionar ao Carrinho'
      end

      visit '/carrinho'
      click_button 'Finalizar Pedido'

      expect(page).to have_content('realizado com sucesso')
    end
  end

  context "Mesmo usuário atuando como vendedor e comprador" do
    let!(:outro_vendedor) { User.create!(nome: "Outra Loja", email: "outraloja@teste.com", password: "senha789", cpf: "444.444.444-44") }
    let!(:outro_produto) { Product.create!(nome: "Torta de Chocolate", preco: 30.0, estoque: 5, vendedor_id: outro_vendedor.id) }

    before do
      visit '/login'
      fill_in 'email', with: vendedor.email
      fill_in 'senha', with: 'senha123'
      click_button 'Acessar Conta'
    end

    it "publica um produto próprio e também compra de outro vendedor com a mesma conta" do
      visit '/produtos'
      find("a[href='/produtos/novo']").click
      fill_in 'nome', with: 'Torta de Morango'
      fill_in 'descricao', with: 'Torta deliciosa'
      fill_in 'preco', with: '50.00'
      fill_in 'estoque', with: '10'
      click_button 'Adicionar ao Catálogo'

      expect(page).to have_content('Torta de Morango')

      visit '/produtos'
      find(".product-card", text: "Torta de Chocolate").click_link("Ver Detalhes")

      within("form[action='/carrinho/adicionar']") do
        fill_in 'quantidade', with: '1'
        click_button 'Adicionar ao Carrinho'
      end

      visit '/carrinho'
      click_button 'Finalizar Pedido'

      expect(page).to have_content('realizado com sucesso')

      visit '/produtos/meus'
      expect(page).to have_content('Torta de Morango')

      visit '/compras'
      expect(page).to have_content('R$ 30,00')

      visit '/vendas'
      expect(page).to have_content('Você ainda não recebeu nenhum pedido')
    end
  end
end
