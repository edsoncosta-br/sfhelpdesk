module RequestsHelper
  def status(status)
    if status == Constants::STEP_ABERTA[1]
      'Abertas'
    elsif status == Constants::STEP_FINALIZADA[1]
      'Finalizadas'
    elsif status == Constants::STEP_ARQUIVADA[1]
      'Arquivadas'
    end 
  end 

  def color_status(status)
    if status == Constants::STEP_ABERTA[1]
      'open-status'
    elsif status == Constants::STEP_FINALIZADA[1]
      'finish-status'
    elsif status == Constants::STEP_ARQUIVADA[1]
      'archived-status'
    end 
  end

  def step(step)
    if step == Constants::STATUS_EXECUTANDO[1]
      Constants::STATUS_EXECUTANDO[0]
    elsif step == Constants::STATUS_AGUARDANDO[1]
      Constants::STATUS_AGUARDANDO[0]
    elsif step == Constants::STATUS_CONCLUIDA[1]
      Constants::STATUS_CONCLUIDA[0]
    elsif step == Constants::STATUS_PAUSADA[1]
      Constants::STATUS_PAUSADA[0]
    end 
  end

  def bg_step(step)
    if step == Constants::STATUS_EXECUTANDO[1]
      'bg-style bg-step bg-step-execute'
    elsif step == Constants::STATUS_AGUARDANDO[1]
      'bg-style bg-step bg-step-wait'
    elsif step == Constants::STATUS_CONCLUIDA[1]
      'bg-style bg-step bg-step-finish'
    elsif step == Constants::STATUS_PAUSADA[1]
      'bg-style bg-step bg-step-pause'
    end 
  end

  def bg_step_show(step)
    if step == Constants::STATUS_EXECUTANDO[1]
      'bg-style bg-step-show bg-step-execute'
    elsif step == Constants::STATUS_AGUARDANDO[1]
      'bg-style bg-step-show bg-step-wait'
    elsif step == Constants::STATUS_CONCLUIDA[1]
      'bg-style bg-step-show bg-step-finish'
    elsif step == Constants::STATUS_PAUSADA[1]
      'bg-style bg-step-show bg-step-pause'
    end 
  end

  def tags_show(request_id)
    RequestTag.select(:description)
              .joins(:tag)
              .where('request_id = ?',request_id)
  end
end