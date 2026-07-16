module FlashHelper
  def flash_message(type, message)
    if type == :error
      session[:flash_error] = message
    else
      session[:flash_success] = message
    end
  end

  def render_flash
    html = ""
    
    if session[:flash_error]
      html += "<div class='alert-error' style='padding: 10px; border-radius: 8px; margin-bottom: 20px; text-align: center;'>"
      html += "<p style='margin:0;'>#{session[:flash_error]}</p></div>"
      session.delete(:flash_error)
    end
    
    if session[:flash_success]
      html += "<div class='alert-success' style='padding: 10px; border-radius: 8px; margin-bottom: 20px; text-align: center;'>"
      html += "<p style='margin:0;'>#{session[:flash_success]}</p></div>"
      session.delete(:flash_success)
    end

    html
  end
end