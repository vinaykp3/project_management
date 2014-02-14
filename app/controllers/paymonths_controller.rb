class PaymonthsController < ApplicationController

  def new
    @paymonth = Paymonth.new
  end

  def create
   @paydate = Paymonth.to_from_date_create paymonth_params[:month_year]
   if @paydate.save!
      flash[:success] = "New paymonth has been created"
      redirect_to paymonths_url
    else
      render'new'
    end
  end

  def show
   @paymonth = Paymonth.find(params[:id])
  end

  def index
    @paymonth = Paymonth.all
  end

  def edit
    @paymonth = Paymonth.find(params[:id])
  end

  def update
    @paymonth = Paymonth.find(params[:id])
    if @paymonth.update(paymonth_params)
      redirect_to paymonths_url
    else
      render'edit'
    end
  end

  def destroy
    @paymonth = Paymonth.find(params[:id]).destroy
    redirect_to paymonths_url
  end

  private
    def paymonth_params
      params.require(:paymonth).permit(:month_year,:from_date,:to_date)
    end

end
