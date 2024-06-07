class CitiesController < ApplicationController
  def index
  end

  def search
    cities = City.order(Arel.sql('unaccent(name)'))

    if !params[:search_name].empty?
      cities = cities.where('unaccent(name) ilike unaccent(?)', "%#{params[:search_name]}%")
    end    

    if !params[:search_uf].empty?
      cities = cities.where('state = ?', params[:search_uf])
    end        

    if !params[:search_ibge_code].empty?
      cities = cities.where(' cast(ibge_code as varchar(7)) like ?', "#{params[:search_ibge_code]}%")
    end

    @cities = cities.all.page(params[:page]).per(Constants::PAGINAS)
    @cities_size = cities.size

    respond_to do |format|
      format.js
    end  
  end

  def filter
    if !params[:customer][:state].empty?
      @cities = City.select(:id, :name).order('unaccent(name)').where('state = ?', params[:customer][:state]);
    else
      @cities = ''
    end
  end
end
