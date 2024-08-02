class MarksController < ApplicationController
  before_action :set_mark, only: %i[ edit update destroy ]

  def index
    marks = Mark.select(:id, :description, :due_date, :release_date, 'projects.description project_description')
                .joins(project: :company)
                .where("company_id = ?", current_user.company.id)
                .order(Arel.sql('unaccent(projects.description), unaccent(marks.description)'))

    if params[:q_sys].blank?
      params[:q_sys] = Allocation.joins(:project)
                                  .joins(project: :company)
                                  .where("company_id = ? and allocations.user_id = ?", current_user.company.id, current_user.id)
                                  .order("unaccent(description)")
                                  .pick('projects.id')

      if params[:q_sys].blank?
        params[:q_sys] = 0
      end                                  
    end

    marks = marks.where('projects.id = ?', "#{params[:q_sys]}")

    if !params[:q_desc].blank?
      marks = marks.where('unaccent(marks.description) ilike unaccent(?)', "%#{params[:q_desc]}%")
    end

    @marks = marks.all.page(params[:page]).per(Constants::PAGINAS)
    @marks_size = marks.size    
  end

  def new
    @mark = Mark.new
    @mark.project_id = params[:q_sys]    
  end

  def create
    @mark = Mark.new(mark_params)
    
    respond_to do |format|
      if @mark.save
        format.html { redirect_to marks_path(q_sys: params[:q_sys],
                                             q_desc: params[:q_desc]), notice: "Meta cadastrada com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @mark.update(mark_params)
      redirect_to marks_path(q_sys: params[:q_sys],
                              q_desc: params[:q_desc]), notice: "Meta atualizada com sucesso."
    else
      render :edit
    end      
  end  

  def destroy
    begin
      if @mark.destroy
        redirect_to marks_path(q_sys: params[:q_sys],
                                q_desc: params[:q_desc]), notice: "Meta excluída com sucesso."
      else
        redirect_to marks_path(q_sys: params[:q_sys],
                                q_desc: params[:q_desc])
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to marks_path(q_sys: params[:q_sys],
                              q_desc: params[:q_desc])
    end
  end

  private

  def set_mark
    @mark = Mark.find(params[:id])
  end

  def mark_params
    params.require(:mark).permit(:description, :due_date, :release_date, :project_id)
  end  

end
