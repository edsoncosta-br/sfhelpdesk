class RequestMailer < ApplicationMailer
  # Requisição - Criação
  def request_created
    subject = "Nova requisição em " + params[:project_description] + ' - ' +
              params[:request_title]

    @email = params[:email]
    @name = params[:name]
    @name_created = params[:name_created]
    @project_description = params[:project_description]
    @request_id = params[:request_id]
    @request_title = params[:request_title]

    mail(to: @email, subject: subject)
  end

  # Requisição - Finalização
  def request_finished
    subject = "Requisição finalizada em " + params[:project_description] + ' - ' +
              params[:request_title]

    @email = params[:email]
    @name = params[:name]
    @name_finished = params[:name_finished]
    @project_description = params[:project_description]
    @request_id = params[:request_id]
    @request_title = params[:request_title]

    mail(to: @email, subject: subject)
  end  

  # Comentarios - Criacao
  def request_comment_created
    subject = "Novo comentário em " + params[:project_description] + ' - ' +
              params[:request_title]

    @email = params[:email]
    @name = params[:name]
    @name_created = params[:name_created]
    @project_description = params[:project_description]
    @request_id = params[:request_id]
    @request_title = params[:request_title]

    mail(to: @email, subject: subject)    
  end

  # Meta - Finalização
  def mark_finished
    subject = "Meta finalizada em " + params[:project_description] + ' - ' +
              params[:mark_title]

    @email = params[:email]
    @name = params[:name]
    @project_description = params[:project_description]
    @mark_id = params[:mark_id]
    @mark_title = params[:mark_title]

    mail(to: @email, subject: subject)    
  end
      
end
