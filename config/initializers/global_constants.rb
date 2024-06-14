module Constants
  CPF_TAMANHO = 11
  CNPJ_TAMANHO = 14

  CNPJ_SELECT = 1
  CPF_SELECT = 2

  TYPE_PERSON_FISICA = 'Física'
  TYPE_PERSON_JURIDICA = 'Jurídica'

  PAGINAS = 40
  PAGINATE_WINDOW = 1

  NEW_MODE = 0
  EDIT_MODE = 1
  
  DEFAULT_PASSWORD = '123456'

  PROCESS_BATCH_STATUS_ANDAMENTO =  1
  PROCESS_BATCH_STATUS_CANCELADO  =  2
  PROCESS_BATCH_STATUS_FINALIZADO =  3

  PROCESS_STAGE_STATUS_AGUARDANDO =  1
  PROCESS_STAGE_STATUS_CONCLUIDO =  2

  BATCH_TYPE_DESTINATION_ADMIN = 1
  BATCH_TYPE_DESTINATION_CLIENTE = 2
  BATCH_TYPE_DESTINATION_AMBAS = 3

  BATCH_LOG_DELETE = 'EXCLUSÃO'
  BATCH_LOG_REOPEN = 'REABERTURA'


  UF_ARRAY = ['AC', 
              'AL', 
              'AM', 
              'AP', 
              'BA', 
              'CE', 
              'DF', 
              'ES', 
              'GO', 
              'MA', 
              'MG', 
              'MS', 
              'MT', 
              'PA', 
              'PB', 
              'PE', 
              'PI', 
              'PR', 
              'RJ', 
              'RN', 
              'RO', 
              'RR', 
              'RS', 
              'SC', 
              'SE', 
              'SP', 
              'TO']
              

end