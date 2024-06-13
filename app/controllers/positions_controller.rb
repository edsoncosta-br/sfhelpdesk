class PositionsController < ApplicationController
  before_action :set_position, only: %i[ edit update destroy ]

  def index
  end

  def new
    @position = Position.new
  end

  def create
    @position = Position.new(position_params)
    
    respond_to do |format|
      if @position.save
        format.html { redirect_to positions_path, notice: "Cargo/Função cadastrado com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @position.update(position_params)
      redirect_to positions_path, notice: "Cargo/Função atualizado com sucesso."
    else
      render :edit
    end      
  end  

  def destroy
    begin
      if @position.destroy
        redirect_to positions_path, notice: "Cargo/Função excluído com sucesso."
      else
        redirect_to positions_path
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to positions_path
    end
  end  

  def search
    positions = Position.order(Arel.sql('unaccent(description)'))

    if !params[:search_description].empty?
      positions = positions.where('unaccent(description) ilike unaccent(?)', "%#{params[:search_description]}%")
    end    

    @positions = positions.all.page(params[:page]).per(Constants::PAGINAS)
    @positions_size = positions.size

    respond_to do |format|
      format.js
    end  
  end

  private

  def set_position
    @position = Position.find(params[:id])
  end

  def position_params
    params.require(:position).permit(:description)
  end  

end
