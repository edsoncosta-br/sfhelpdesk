class RequestMailer < ApplicationMailer
  # Requisição
  # - Criação
  # - Finalização
  
  # Comentarios
  # - Criacao
    
  # Meta
  # - Finalização

  def request_created
    subject = "Uma nova requisição foi criada para o projeto " + params[:project_description]

    @email = params[:email]
    @name = params[:name]
    @name_created = params[:name_created]
    @project_description = params[:project_description]
    @request_id = params[:request_id]
    @request_title = params[:request_title]

    mail(to: @email, subject: subject)    
  end

  def request_finished
  end  

  def request_comment_created
  end

  def mark_finished
  end
      
end
