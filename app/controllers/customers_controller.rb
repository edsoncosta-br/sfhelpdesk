class CustomersController < ApplicationController
  before_action :set_customer, only: %i[ edit update destroy show ]
  before_action :set_upcase, only: %i[ create update ]    

  def index
    customers = Customer.select(:id, :code, :name, :cpfcnpj_number, :active, 'cities.name city_name, cities.state city_state')
                                .joins(:city)
                                .where("company_id = ?", current_user.company.id)
                                .order(Arel.sql('unaccent(customers.name)'))

    if !params[:q_name].blank?
      customers = customers.where('unaccent(customers.name) ilike unaccent(?)', "%#{params[:q_name]}%")
    end    

    if !params[:q_code].blank?
      customers = customers.where('code = ?', "#{params[:q_code]}")
    end

    @customers = customers.all.page(params[:page]).per(Constants::PAGINAS)
    @customers_size = customers.size
  end

  def new
    @customer = Customer.new
    @customer.type_person = Constants::TYPE_PERSON_JURIDICA
    next_code
  end

  def create
    @customer = Customer.new(customer_params)
    @customer.company_id = current_user.company.id

    code_generated

    respond_to do |format|
      if @customer.save
        format.html { redirect_to customers_path( q_name: params[:q_name],
                                                  q_code: params[:q_code]), notice: "Cliente cadastrado com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @customer.state = @customer.city.state
  end

  def show
    @customer.state = @customer.city.state
  end

  def update
    if @customer.update(customer_params)
      redirect_to customers_path( q_name: params[:q_name],
                                  q_code: params[:q_code]), notice: "Cliente atualizado com sucesso."
    else
      render :edit
    end
  end    

  def destroy
    begin
      if @customer.destroy
        redirect_to customers_path( q_name: params[:q_name],
                                    q_code: params[:q_code]), notice: "Cliente excluído com sucesso."
      else
        render :index
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to customers_path( q_name: params[:q_name],
                                  q_code: params[:q_code])
    end
  end    

  private

  def set_upcase
    Methods.field_upcase(params[:customer])
  end    

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit( :code, :name, :address, :number,
                                      :complement, :district, :cpfcnpj_number, :zip_code,
                                      :email, :active, :city_id, :company_id, :state, :code_generated, 
                                      :type_person, :phone, :cellphone)
  end

  def next_code
    # Salva o ultimo codigo automatico (nao digitado pelo usuario) mais 1
    code = (Customer
            .where("code_typed = false")
            .where("company_id = ?", current_user.company.id)
            .maximum("code").to_i + 1)

    # Verifica se o code salvo ja existe por digitacao manual. Acrescenta 1 ate nao encontrar
    while !Customer
          .where("code_typed = true and code = ? ", code)
          .where("company_id = ?", current_user.company.id)
          .empty? do
      code += 1
    end

    @customer.code = code.to_s.rjust(5, '0')
    @customer.code_generated = @customer.code
  end

  def code_generated
    # Verifica se o codigo retornado da view nao é o mesmo do gerado 
    # automaticamente em new (foi digitado pelo usuario um codigo diferente) e salva
    if params[:code_generated].to_i != @customer.code
      @customer.code_typed = true
    end  
  end

end
