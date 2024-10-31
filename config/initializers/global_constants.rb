module Constants
  CPF_TAMANHO = 11
  CNPJ_TAMANHO = 14

  CNPJ_SELECT = 1
  CPF_SELECT = 2

  TYPE_PERSON_FISICA = 'Física'
  TYPE_PERSON_JURIDICA = 'Jurídica'

  STATUS_ABERTA = ['Aberta', 1]
  STATUS_FINALIZADA = ['Finalizada', 2]
  STATUS_ARQUIVADA = ['Arquivada', 3]

  STATUS_ABERTA_PLUR = ['Abertas', 1]
  STATUS_FINALIZADA_PLUR = ['Finalizadas', 2]
  STATUS_ARQUIVADA_PLUR = ['Arquivadas', 3]  

  PRIORITY_ALTA = ['Alta',1]
  PRIORITY_MEDIA = ['Média', 2]
  PRIORITY_BAIXA = ['Baixa', 3]

  STEP_EXECUTANDO = ['Em Andamento',1]
  STEP_AGUARDANDO = ['Aguardando', 2]
  STEP_CONCLUIDA = ['Concluída', 3]

  PAGINAS = 25
  PAGINATE_WINDOW = 1

  NEW_MODE = 0
  EDIT_MODE = 1
  
  DEFAULT_PASSWORD = '123456'


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