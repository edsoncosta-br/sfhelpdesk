class AllocationsController < ApplicationController
  before_action :set_allocation, only: %i[ edit update destroy ]  

  def index
    allocations = Allocation.select(:id, :main, :system_id, :user_id, 
                                    :description, :name, '')
                      .joins(system: :company)
                      .joins(:user)
                      .where("users.company_id = ?", current_user.company.id)
                      .order(Arel.sql('unaccent(systems.description), unaccent(allocations.description)'))

    if params[:q_sys].blank?
      params[:q_sys] = System.joins(:company)
                              .where("company_id = ?", current_user.company.id)
                              .order("unaccent(description)")
                              .pick('systems.id')      
    end

    if !params[:q_sys].blank?
      allocations = allocations.where('systems.id = ?', "#{params[:q_sys]}")
    end

    @allocations = allocations.all.page(params[:page]).per(Constants::PAGINAS)
    @allocations_size = allocations.size    
  end

  def new
    @allocation = Allocation.new
  end

  def create
    @allocation = Allocation.new(allocation_params)
    
    respond_to do |format|
      if @allocation.save
        format.html { redirect_to allocations_path(q_sys: params[:q_sys]), notice: "Alocação cadastrada com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @allocation.update(allocation_params)
      redirect_to allocations_path(q_sys: params[:q_sys]), notice: "Alocação atualizada com sucesso."
    else
      render :edit
    end      
  end  

  def destroy
    begin
      if @allocation.destroy
        redirect_to allocations_path(q_sys: params[:q_sys],
                                q_desc: params[:q_desc]), notice: "Alocação excluída com sucesso."
      else
        redirect_to allocations_path(q_sys: params[:q_sys],
                                q_desc: params[:q_desc])
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to allocations_path(q_sys: params[:q_sys],
                              q_desc: params[:q_desc])
    end
  end      

  private

  def set_allocation
    @allocation = Allocation.find(params[:id])
  end

  def allocation_params
    params.require(:allocation).permit(:main, :user_id,  :system_id)
  end    

end
