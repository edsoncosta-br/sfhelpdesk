class PositionsController < ApplicationController
  before_action :set_position, only: %i[ edit update destroy show]
  before_action :set_menu_admin
  before_action :set_upcase, only: %i[ create update ]    

  def index
    positions = Position.where("company_id = ?", current_user.company.id)
                        .order(Arel.sql('unaccent(description)'))

    if !params[:q_desc].blank?
      positions = positions.where('unaccent(description) ilike unaccent(?)', "%#{params[:q_desc]}%")
    end    

    @positions = positions.all.page(params[:page]).per(Constants::PAGINAS)
    @positions_size = positions.size    
  end

  def new
    @position = Position.new
  end

  def create
    @position = Position.new(position_params)
    @position.company_id = current_user.company.id
    
    respond_to do |format|
      if @position.save
        format.html { redirect_to positions_path(q_desc: params[:q_desc]), notice: "Cargo/Função cadastrado com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def show
  end  

  def update
    if @position.update(position_params)
      redirect_to positions_path(q_desc: params[:q_desc]), notice: "Cargo/Função atualizado com sucesso."
    else
      render :edit
    end      
  end  

  def destroy
    begin
      if @position.destroy
        redirect_to positions_path(q_desc: params[:q_desc]), notice: "Cargo/Função excluído com sucesso."
      else
        redirect_to positions_path(q_desc: params[:q_desc])
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to positions_path(q_desc: params[:q_desc])
    end
  end

  private

  def set_upcase
    Methods.field_upcase(params[:position])
  end    

  def set_position
    @position = Position.find(params[:id])
  end

  def position_params
    params.require(:position).permit(:description, :company_id)
  end

  def set_menu_admin
    menu_admin
  end

end
