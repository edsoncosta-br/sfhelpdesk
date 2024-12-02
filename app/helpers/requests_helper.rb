module RequestsHelper
  def status(status)
    if status == Constants::STATUS_ABERTA[1]
      'Abertas'
    elsif status == Constants::STATUS_FINALIZADA[1]
      'Finalizadas'
    elsif status == Constants::STATUS_ARQUIVADA[1]
      'Arquivadas'
    end 
  end 

  def status_request(status)
    if status == Constants::STATUS_ABERTA[1]
      'Aberta'
    elsif status == Constants::STATUS_FINALIZADA[1]
      'Finalizada'
    elsif status == Constants::STATUS_ARQUIVADA[1]
      'Arquivada'
    end 
  end   

  def color_status(status)
    if status == Constants::STATUS_ABERTA[1]
      'open-status'
    elsif status == Constants::STATUS_FINALIZADA[1]
      'finish-status'
    elsif status == Constants::STATUS_ARQUIVADA[1]
      'archived-status'
    end 
  end

  def color_mark(closed)
    if closed == true
      'bg-mark-closed'
    elsif closed == false
      'bg-mark-open'
    end 
  end

  def mark_description(closed)
    if closed == true
      "Meta Finalizada"
    elsif closed == false
      "Meta Aberta"
    end 
  end    

  def status_step(step)
    if step == Constants::STEP_EXECUTANDO[1]
      Constants::STEP_EXECUTANDO[0]
    elsif step == Constants::STEP_AGUARDANDO[1]
      Constants::STEP_AGUARDANDO[0]
    elsif step == Constants::STEP_TESTE[1]
      Constants::STEP_TESTE[0]      
    elsif step == Constants::STEP_CONCLUIDA[1]
      Constants::STEP_CONCLUIDA[0]
    end 
  end

  def bs_title(step)
    if step == Constants::STEP_EXECUTANDO[1]
      'Execução em Andamento'
    elsif step == Constants::STEP_AGUARDANDO[1]
      'Aguardando Execução'
    elsif step == Constants::STEP_TESTE[1]
      'Requisição Liberada para Testes'
    elsif step == Constants::STEP_CONCLUIDA[1]
      'Execução e Testes Concluídos'
    end     
  end

  def bg_step(step)
    if step == Constants::STEP_EXECUTANDO[1]
      'bg-style bg-step bg-step-execute'
    elsif step == Constants::STEP_AGUARDANDO[1]
      'bg-style bg-step bg-step-wait'
    elsif step == Constants::STEP_TESTE[1]
      'bg-style bg-step bg-step-test'      
    elsif step == Constants::STEP_CONCLUIDA[1]
      'bg-style bg-step bg-step-finish'
    end 
  end

  def bg_status(status)
    if status == Constants::STATUS_ABERTA[1]
      'bg-status-open'
    elsif status == Constants::STATUS_FINALIZADA[1]
      'bg-status-finish'
    elsif status == Constants::STATUS_ARQUIVADA[1]
      'bg-status-archived'
    end     
  end

  def tags_show(request_id)
    RequestTag.select(:description)
              .joins(:tag)
              .where('request_id = ?',request_id)
  end

  def collapse_btn 
    if  params[:q_tag].blank? or 
        params[:q_customer].blank? or
        params[:q_mark].blank? or 
        params[:q_responsible].blank?
      'aria-expanded=false class=collapsed'
    else
      'aria-expanded=true class='
    end
  end

  def collapse_line
    if  !params[:q_tag].blank? or 
        !params[:q_customer].blank? or
        !params[:q_mark].blank? or 
        !params[:q_responsible].blank?
      'collapse show'
    else
      'collapse'
    end
  end 
end