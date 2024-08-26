require 'csv'

DEFAULT_PASSWORD = 123456
DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

namespace :dev do

  desc 'Setting development environment'
  task setup: :environment do
    if Rails.env.development?
      puts 'Dropping database...'  
      puts %x(rails db:drop)
      
      puts 'Creating database...' 
      puts %x(rails db:create)
      
      puts 'Migrating database...' 
      puts %x(rails db:migrate)

      puts 'Adding company...'
      puts %x(rails dev:add_company)      

      puts 'Adding positions...'
      puts %x(rails dev:add_position)

      puts 'Adding cities...'
      puts %x(rails dev:add_cities)

      puts 'Adding default user'
      puts %x(rails dev:add_default_user)      
    
      # puts 'Adding default admin'
      # puts %x(rails dev:add_default_admin)

      puts 'Add customer test user'
      puts %x(rails dev:add_default_customer)      
    else
      puts 'You are not in development environment!'
    end
  end

  desc 'Add default company'
  task add_company: :environment do
    Company.create!(
      name: 'Sófolha Soluções Corporativas')
  end

  desc 'Add default position'
  task add_position: :environment do
    Position.create!(
      description: 'Desenvolvimento', company_id: 1)
    Position.create!(
      description: 'Suporte Técnico', company_id: 1)
    Position.create!(
      description: 'Comercial', company_id: 1)
  end

  desc 'Adding cities...'
  task add_cities: :environment do
    file_name = 'cities.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)
    
    File.open(file_path, 'r').each do |line|
      # Exemplo: 5300108|Brasília|01012009|
      ibgecode = line[0,7]
      cityname =  line.strip[8, (line.strip.size - 18)]

      if line[0,2] == '12'
        state = 'AC'
      elsif line[0,2] == '27'
        state = 'AL'
      elsif line[0,2] == '16'
        state = 'AP'
      elsif line[0,2] == '13'
        state = 'AM'
      elsif line[0,2] == '29'
        state = 'BA'
      elsif line[0,2] == '23'
        state = 'CE'
      elsif line[0,2] == '53'
        state = 'DF'
      elsif line[0,2] == '32'
        state = 'ES'
      elsif line[0,2] == '52'
        state = 'GO'
      elsif line[0,2] == '21'
        state = 'MA'
      elsif line[0,2] == '51'
        state = 'MT'
      elsif line[0,2] == '50'
        state = 'MS'
      elsif line[0,2] == '31'
        state = 'MG'
      elsif line[0,2] == '15'
        state = 'PA'
      elsif line[0,2] == '25'
        state = 'PB'
      elsif line[0,2] == '41'
        state = 'PR'
      elsif line[0,2] == '26'
        state = 'PE'
      elsif line[0,2] == '22'
        state = 'PI'
      elsif line[0,2] == '33'
        state = 'RJ'
      elsif line[0,2] == '24'
        state = 'RN'
      elsif line[0,2] == '43'
        state = 'RS'
      elsif line[0,2] == '11'
        state = 'RO'
      elsif line[0,2] == '14'
        state = 'RR'
      elsif line[0,2] == '42'
        state = 'SC'
      elsif line[0,2] == '35'
        state = 'SP'
      elsif line[0,2] == '28'
        state = 'SE'
      elsif line[0,2] == '17'
        state = 'TO'
      elsif line[0,2] == '99'
        state = 'EX'
      end
      
      if (ibgecode != 0) || (cityname != 0) || (state != 0)
        City.create!(
          ibge_code: ibgecode, 
          name: cityname, 
          state: state)
      end  
    end
  end  

  desc 'Add default user'
  task add_default_user: :environment do
    User.create!(
      email: 'edson@sofolha.com.br',
      name: 'Edson Benedito da Costa',
      nick_name: 'Edson Costa',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD,
      position_id: 1,
      company_id: 1,
      admin: true,
      permission_admin_menu: true
    )

    User.create!(
      email: 'mara@sofolha.com.br',
      name: 'Mara Sílvia Lopes Thomazini da Costa',
      nick_name: 'Mara Sílvia',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD,
      position_id: 3,
      company_id: 1
    )    
  end    
  
  desc 'Add default admin'
  task add_default_admin: :environment do
    Admin.create!(
      email: 'edson@sofolha.com.br',
      name: 'EDSON COSTA',
      position: 'ADMINISTRADOR',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD,
      company_id: 1
    )
  end

  desc 'Add customer test user'
  task add_default_customer: :environment do
    Customer.create!(
      code: '00001',
      name: 'Prefeitura Municipal de Marília',
      city_id: 1,
      state: 'SP',
      company_id: 1,
      cpfcnpj_number: '41.232.918/0001-43'
    )
    Customer.create!(
      code: '00002',
      name: 'Prefeitura Municipal de Tupã',
      city_id: 10,
      state: 'SP',
      company_id: 1,
      cpfcnpj_number: '68.609.974/0001-00'
    )
    Customer.create!(
      code: '00003',
      name: 'Prefeitura Municipal de Novo Horizonte',
      city_id: 100,
      state: 'SP',
      company_id: 1,
      cpfcnpj_number: '52.618.476/0001-94'
    )
    Customer.create!(
      code: '00004',
      name: 'Prefeitura Municipal de Águas da Prata',
      city_id: 2,
      state: 'SP',
      company_id: 1,
      cpfcnpj_number: '19.425.348/0001-59'
    )
    Customer.create!(
      code: '00005',
      name: 'Prefeitura Municipal de Monte Azul Paulista',
      city_id: 20,
      state: 'SP',
      company_id: 1,
      cpfcnpj_number: '82.958.315/0001-00'
    )
    Customer.create!(
      code: '00006',
      name: 'Prefeitura Municipal de São João da Boa Vista',
      city_id: 200,
      state: 'SP',
      company_id: 1,
      cpfcnpj_number: '58.878.593/0001-73'
    )
  end
end

# Supervisor.create!(email: 'edson@sofolha.com.br', name: 'EDSON COSTA', position: 'ADMINISTRADOR', password: '111111', password_confirmation: '111111', administrator: true)