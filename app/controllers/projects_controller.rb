class ProjectsController < ApplicationController

  def new
   @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:success] = "Project Created Successfully"
      redirect_to projects_url
    else
      flash[:danger] = @project.errors.full_messages
      redirect_to new_project_path
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def index
    @project = Project.all
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
