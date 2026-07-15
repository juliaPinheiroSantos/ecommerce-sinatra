module AuthHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_login!
    unless logged_in?
        flash_message(:error, "Você precisa fazer login para acessar esta página.")
      redirect '/login'
    end
  end

  def require_vendedor!
    require_login!
    unless current_user.vendedor?
      flash_message(:error, "Acesso negado. Apenas a equipe da confeitaria pode acessar esta área.")
      redirect '/'
    end
  end

  def require_cliente!
    require_login!
    unless current_user.cliente?
      flash_message(:error, "Sua conta é de gerenciamento. Você não pode realizar compras.")
      redirect '/'
    end
  end
end