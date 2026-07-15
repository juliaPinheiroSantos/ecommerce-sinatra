require 'spec_helper'

RSpec.describe "Fluxo Completo da Confeitaria", type: :feature do
  # Vendedor é criado diretamente no banco: a aplicação não permite
  # cadastro público de vendedor, apenas via seeds (regra de negócio).
  let!(:vendedor) { User.create!(nome: "Thalita", email: "thalita@doces.com", password: "senha123", tipo: "vendedor", cpf: "000.000.000-00") }

  context "Como Vendedor" do
    let!(:cliente_comprador) { User.create!(nome: "Cliente Comprador", email: "comprador@teste.com", password: "senha456", tipo: "cliente", cpf: "222.222.222-22") }

    before do
      visit '/login'
      fill_in 'email', with: vendedor.email
      fill_in 'senha', with: 'senha123'
      click_button 'Acessar Conta'
    end

    it "publica produto, recebe pedido de um cliente e avança o status do pedido" do
      visit '/produtos'
      find("a[href='/produtos/novo']").click
      fill_in 'nome', with: 'Torta de Morango'
      fill_in 'descricao', with: 'Torta deliciosa'
      fill_in 'preco', with: '50.00'
      fill_in 'estoque', with: '10'
      click_button 'Adicionar ao Catálogo'

      expect(page).to have_content('Torta de Morango')

      # Sessão separada simula um segundo usuário (cliente) navegando
      # em paralelo, para que o pedido exista de fato antes de o
      # vendedor tentar avançar o status.
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
      expect(page).to have_content('Paga')
    end
  end

  context "Como Cliente" do
    let!(:vendedor_db) { User.create!(nome: "Vendedor", email: "v@v.com", password: "senha456", tipo: "vendedor", cpf: "333.333.333-33") }
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
end
