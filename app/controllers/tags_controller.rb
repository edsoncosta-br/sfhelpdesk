class TagsController < ApplicationController
  before_action :set_tag, only: %i[ edit update destroy show]

  def index
    tags = Tag.select(:id, :description, 'projects.description project_description')
              .joins(project: :company)
              .where("company_id = ?", current_user.company.id)
              .order(Arel.sql('unaccent(projects.description), unaccent(tags.description)'))

    if params[:q_sys].blank?
      params[:q_sys] = Methods.select_allocations(current_user.company.id, current_user.id)

      if params[:q_sys].blank?
        params[:q_sys] = 0
      end                                  
    end

    tags = tags.where('projects.id = ?', "#{params[:q_sys]}")

    if !params[:q_desc].blank?
      tags = tags.where('unaccent(tags.description) ilike unaccent(?)', "%#{params[:q_desc]}%")
    end

    @tags = tags.all.page(params[:page]).per(Constants::PAGINAS)
    @tags_size = tags.size    
  end

  def new
    @tag = Tag.new
    @tag.project_id = params[:q_sys]    
  end

  def create
    @tag = Tag.new(tag_params)
    
    respond_to do |format|
      if @tag.save
        format.html { redirect_to tags_path(q_sys: params[:q_sys],
                                            q_desc: params[:q_desc],
                                            page: params[:page]), notice: "Tag cadastrada com sucesso." }
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
    if @tag.update(tag_params)
      redirect_to tags_path(q_sys: params[:q_sys],
                            q_desc: params[:q_desc],
                            page: params[:page]), notice: "Tag atualizada com sucesso."
    else
      render :edit
    end      
  end  

  def destroy
    begin
      if @tag.destroy
        redirect_to tags_path(q_sys: params[:q_sys],
                              q_desc: params[:q_desc],
                              page: params[:page]), notice: "Tag excluída com sucesso."
      else
        redirect_to tags_path(q_sys: params[:q_sys],
                              q_desc: params[:q_desc],
                              page: params[:page])
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to tags_path(q_sys: params[:q_sys],
                            q_desc: params[:q_desc],
                            page: params[:page])
    end
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:description, :project_id)
  end  
end
