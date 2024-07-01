class VersionsController < ApplicationController
  before_action :set_version, only: %i[ edit update destroy ]

  def index
    versions = Version.select(:id, :description, :due_date, :release_date, 'systems.description system_description')
                      .joins(system: :company)
                      .where("company_id = ?", current_user.company.id)
                      .order(Arel.sql('unaccent(systems.description), unaccent(versions.description)'))

    if params[:q_sys].blank?
      params[:q_sys] = System.joins(:company)
                              .where("company_id = ?", current_user.company.id)
                              .order("unaccent(description)")
                              .pick('systems.id')      
    end

    if !params[:q_sys].blank?
      versions = versions.where('systems.id = ?', "#{params[:q_sys]}")
    end

    if !params[:q_desc].blank?
      versions = versions.where('unaccent(versions.description) ilike unaccent(?)', "%#{params[:q_desc]}%")
    end

    @versions = versions.all.page(params[:page]).per(Constants::PAGINAS)
    @versions_size = versions.size    
  end

  def new
    @version = Version.new
    @version.system_id = params[:q_sys]    
  end

  def create
    @version = Version.new(version_params)
    
    respond_to do |format|
      if @version.save
        format.html { redirect_to versions_path(q_sys: params[:q_sys],
                                              q_desc: params[:q_desc]), notice: "Versão cadastrado com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @version.update(version_params)
      redirect_to versions_path(q_sys: params[:q_sys],
                              q_desc: params[:q_desc]), notice: "Versão atualizado com sucesso."
    else
      render :edit
    end      
  end  

  def destroy
    begin
      if @version.destroy
        redirect_to versions_path(q_sys: params[:q_sys],
                                q_desc: params[:q_desc]), notice: "Versão excluído com sucesso."
      else
        redirect_to versions_path(q_sys: params[:q_sys],
                                q_desc: params[:q_desc])
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to versions_path(q_sys: params[:q_sys],
                              q_desc: params[:q_desc])
    end
  end    

  private

  def set_version
    @version = Version.find(params[:id])
  end

  def version_params
    params.require(:version).permit(:description, :due_date, :release_date, :system_id)
  end  

end
