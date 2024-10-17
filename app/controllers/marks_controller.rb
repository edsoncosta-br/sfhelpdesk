class MarksController < ApplicationController
  before_action :set_mark, only: %i[ edit update destroy close show ]
  before_action :set_upcase, only: %i[ create update ]    

  def index
    marks = Mark.select(:id, :description, :due_date, 
                        :description_complement, 
                        :closed, 
                        'projects.description project_description',
                        '(select count(requests.id) from requests where requests.mark_id = marks.id) count_requests')
                .joins(project: :company)
                .where("company_id = ?", current_user.company.id)
                .order(Arel.sql('unaccent(projects.description), unaccent(marks.description)'))

    if params[:q_sys].blank?
      params[:q_sys] = Methods.select_allocations(current_user.company.id, current_user.id)

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

  def close
  end  

  def show
    @marks = Mark.select(:id, :description, :due_date, 
                        :description_complement, 
                        :closed, 
                        'projects.description project_description')
                .joins(:project)
                .where("marks.id = ?", params[:id])
  end

  def reopen
    mark = Mark.find(params[:id])
    mark.update(closed: false)

    redirect_to marks_path(params[:id],
                          q_sys: params[:q_sys],
                          q_status: params[:q_status],
                          q_content: params[:q_content]), 
                          notice: "Meta reaberta com sucesso."
  end

  def update
    if params[:closed] 
      @mark.closed = true
    end    

    if @mark.update(mark_params)

      if params[:closed] 
        Request.where('mark_id = ?', @mark.id).update_all(status: Constants::STATUS_FINALIZADA[1])
      end

      redirect_to marks_path( q_sys: params[:q_sys],
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

  def set_upcase
    Methods.field_upcase(params[:mark])
  end    

  def set_mark
    @mark = Mark.find(params[:id])
  end

  def mark_params
    params.require(:mark).permit( :description, :due_date, :description_complement, 
                                  :closed, :project_id)
  end  

end
