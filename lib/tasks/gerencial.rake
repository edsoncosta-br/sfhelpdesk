require 'csv'

DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

namespace :import_gerencial do

  desc 'Setting development environment'
  task setup: :environment do
    if Rails.env.development?
      puts 'Importando clientes gerencial...'
      puts %x(rails dev:add_customer)
    else
      puts 'You are not in development environment!'
    end
  end

  desc 'Importa clientes gerencial'
  task add_customer: :environment do
    
    file_path = File.join(DEFAULT_FILES_PATH, 'clientes.csv')
    csv_text = CSV.read(file_path, col_sep: "|", encoding: "UTF-8")

    Customer.delete_all

    # CLCODIGO| CLFANTAS| CLRAZAO| CLENDERE| CLNUMERO| CLCOMPLE| CLBAIRRO| CLFONE| CLMUNICI| MNCDIBGE| CLCEP| CLCNPJCPF
    # 0         1         2        3          4         5         6         7       8         9         10    11 
    csv_text.each do |row|
      city_file = row[9].scan(/\d/).join('')
      city_id = City.where("ibge_code = ?", city_file).pick(:id)
      code = row[0].scan(/\d/).join('')
      # complement = row[5]

      name = row[1].split(" ").map do |word| 
        if !['da', 'de','do', 'das', 'des', 'dos'].include? word.downcase
          word.capitalize
        else
          word.downcase
        end
      end.join " "

      Customer.create!(
        code: code,
        name: name,
        address: row[3],
        number: row[4],
        complement: row[5].to_s[0,20],
        district: row[6].to_s[0,30],
        city_id: city_id,
        zip_code: row[10],
        type_person: "Jurídica",
        cpfcnpj_number: "01.055.651/0001-41", #row[11],
        state: "SP",
        # cellphone: row[0],
        # email: row[0],
        company_id: 1)
    end    
  end


end

# Supervisor.create!(email: 'edson@sofolha.com.br', name: 'EDSON COSTA', position: 'ADMINISTRADOR', password: '111111', password_confirmation: '111111', administrator: true)