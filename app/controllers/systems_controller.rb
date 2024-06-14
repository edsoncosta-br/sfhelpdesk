class SystemsController < ApplicationController
  before_action :set_system, only: %i[ edit update destroy ]

  def index
  end

  def new
    @system = System.new
  end

  def create
    @system = System.new(system_params)
    @system.company_id = current_user.company.id    
    
    respond_to do |format|
      if @system.save
        format.html { redirect_to systems_path, notice: "Sistema cadastrado com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @system.update(system_params)
      redirect_to systems_path, notice: "Sistema atualizado com sucesso."
    else
      render :edit
    end      
  end  

  def destroy
    begin
      if @system.destroy
        redirect_to systems_path, notice: "Sistema excluído com sucesso."
      else
        redirect_to systems_path
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to systems_path
    end
  end    

  def search
    systems = System.order(Arel.sql('unaccent(description)'))

    if !params[:search_description].empty?
      systems = systems.where('unaccent(description) ilike unaccent(?)', "%#{params[:search_description]}%")
    end    

    @systems = systems.all.page(params[:page]).per(Constants::PAGINAS)
    @systems_size = systems.size

    respond_to do |format|
      format.js
    end  
  end

  private

  def set_system
    @system = System.find(params[:id])
  end

  def system_params
    params.require(:system).permit(:description)
  end    
end
