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

  def step(step)
    if step == Constants::STEP_EXECUTANDO[1]
      Constants::STEP_EXECUTANDO[0]
    elsif step == Constants::STEP_AGUARDANDO[1]
      Constants::STEP_AGUARDANDO[0]
    elsif step == Constants::STEP_CONCLUIDA[1]
      Constants::STEP_CONCLUIDA[0]
    end 
  end

  def bg_step(step)
    if step == Constants::STEP_EXECUTANDO[1]
      'bg-style bg-step-execute'
    elsif step == Constants::STEP_AGUARDANDO[1]
      'bg-style bg-step-wait'
    elsif step == Constants::STEP_CONCLUIDA[1]
      'bg-style bg-step-finish'
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
end