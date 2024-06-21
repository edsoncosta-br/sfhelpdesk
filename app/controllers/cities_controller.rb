class CitiesController < ApplicationController
  def index
    cities = City.order(Arel.sql('unaccent(name)'))
    
    if !params[:q_name].blank?
      cities = cities.where('unaccent(name) ilike unaccent(?)', "%#{params[:q_name]}%")
    end    

    if !params[:q_uf].blank?
      cities = cities.where('state = ?', params[:q_uf])
    end        

    if !params[:q_ibge_code].blank?
      cities = cities.where(' cast(ibge_code as varchar(7)) like ?', "#{params[:q_ibge_code]}%")
    end

    @cities = cities.all.page(params[:page]).per(Constants::PAGINAS)
    @cities_size = cities.size    
  end

  def filter
    if !params[:customer][:state].empty?
      @cities = City.select(:id, :name).order('unaccent(name)').where('state = ?', params[:customer][:state]);
    else
      @cities = ''
    end
  end
end
