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

  def colorstatus(status)
    if status == Constants::STEP_ABERTA[1]
      'open-status'
    elsif status == Constants::STEP_FINALIZADA[1]
      'finish-status'
    elsif status == Constants::STEP_ARQUIVADA[1]
      'archived-status'
    end 

  end
end
