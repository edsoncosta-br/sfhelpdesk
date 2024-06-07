class PositionsController < ApplicationController
  def index
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

end
