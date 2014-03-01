class ProjectsController < ApplicationController

  def new
   @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save!
      flash[:success] = "Project Created Successfully"
      redirect_to projects_url
    else
      render 'new'
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def index
    @project = Project.all
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to projects_url
    else
      render'edit'
    end
  end

  def destroy
    @project = Project.find(params[:id]).destroy
    redirect_to projects_url
  end

  private

  def project_params
    params.require(:project).permit(:project_name, :project_commence_date, :project_completion_date)
  end
end
