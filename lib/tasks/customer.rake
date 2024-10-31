require 'csv'

FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

namespace :import_customer do

  desc 'Setting development environment'
  task setup: :environment do
    if Rails.env.development?
      puts 'Importando clientes...'
      puts %x(rails dev:add_customer)
    else
      puts 'You are not in development environment!'
    end
  end

  task add_customer: :environment do
    require "cpf_cnpj"
    
    puts 'Importando Clientes...'  
    file_path = File.join(FILES_PATH, 'clientes.csv')
    csv_cliente = CSV.read(file_path, col_sep: "|", encoding: "UTF-8")

    file_path = File.join(FILES_PATH, 'emails.csv')
    csv_email = CSV.read(file_path, col_sep: "|", encoding: "UTF-8")    

    file_path = File.join(FILES_PATH, 'fones.csv')
    csv_fone = CSV.read(file_path, col_sep: "|", encoding: "UTF-8")        

    Customer.delete_all

    # CLCODIGO| CLFANTAS| CLRAZAO| CLENDERE| CLNUMERO| CLCOMPLE| CLBAIRRO| CLFONE| CLMUNICI| MNCDIBGE| CLCEP| CLCNPJCPF
    # 0         1         2        3          4         5         6         7       8         9         10    11 
    csv_cliente.each do |row|
      
      # ---- CNPJ/CPF
      if row[11].length == 11
        cpf_cnpj = CPF.new(row[11])
        type_person = 'Física'
      else
        cpf_cnpj = CNPJ.new(row[11])
        type_person = 'Jurídica'
      end        

      cpf_cnpj = cpf_cnpj.formatted      

      # ---- Municipio
      city_file = row[9].scan(/\d/).join('')
      city_id = City.where("ibge_code = ?", city_file).pick(:id)
      
      # ---- Codigo cliente
      code = row[0].scan(/\d/).join('')

      # ---- Capitalizacao nome
      name = row[1].split(" ").each_with_index.map do |word, index| 
        # primeiro nome importa maiuscula se, possuir ate 3 sem ponto, ou possuir ate 6 com ponto
        if (index == 0 and word.length <= 3) or
           (index == 0 and word.length <= 6 and word.include? ".")
          word.upcase
        else
          if !['da', 'de','do', 'das', 'des', 'dos'].include? word.downcase
            word.capitalize
          else
            word.downcase
          end
        end
      end.join " "

      # ---- Capitalizacao endereco
      endereco = row[3].split(" ").each_with_index.map do |word, index| 
        if !['da', 'de','do', 'das', 'des', 'dos'].include? word.downcase
          word.capitalize
        else
          word.downcase
        end
      end.join " "

      # ---- Capitalizacao complemento
      if !row[5].blank?
        complemento = row[5].split(" ").each_with_index.map do |word, index| 
          if !['da', 'de','do', 'das', 'des', 'dos'].include? word.downcase
            word.capitalize
          else
            word.downcase
          end
        end.join " "
      end

      # ---- Capitalizacao bairro
      if !row[6].blank?
        bairro = row[6].split(" ").each_with_index.map do |word, index| 
          if !['da', 'de','do', 'das', 'des', 'dos'].include? word.downcase
            word.capitalize
          else
            word.downcase
          end
        end.join " "
      end

      # ---- Email
      email_cliente = ""
      csv_email.each do |row_email|
        if row_email[0].scan(/\d/).join('') == code
          email_cliente = row_email[1]
          break
        end
      end

      # ---- Fones
      fone_cliente = ""
      csv_fone.each do |row_fone|
        if row_fone[0].scan(/\d/).join('') == code
          fone_cliente = "(" + row_fone[1][0,2] + ") " + row_fone[1][2,5] + "-" + row_fone[1][7,4]
          break
        end
      end  
      
      # ---- CEP
      if !row[10].blank?
        zip_code = row[10][0,5] + "-" + row[10][5,3]
      end

      Customer.create!(
        code: code,
        name: name,
        address: endereco.to_s[0,50],
        number: row[4],
        complement: complemento.to_s[0,20],
        district: bairro.to_s[0,30],
        city_id: city_id,
        zip_code: zip_code,
        type_person: type_person,
        cpfcnpj_number: cpf_cnpj,
        state: "SP",
        cellphone: fone_cliente,
        email: email_cliente.to_s[0,60],
        company_id: 1)
    end    
  end


end

# Supervisor.create!(email: 'edson@sofolha.com.br', name: 'EDSON COSTA', position: 'ADMINISTRADOR', password: '111111', password_confirmation: '111111', administrator: true)