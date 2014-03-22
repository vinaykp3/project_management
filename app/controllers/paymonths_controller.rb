class PaymonthsController < ApplicationController

  def new
    @paymonth = Paymonth.new
  end

  def create
   if params[:paymonth][:month_year]!= ""
     start_date, end_date = Paymonth.to_from_date_create paymonth_params[:month_year]
     params[:paymonth][:from_date] = start_date
     params[:paymonth][:to_date] = end_date
   end
   @paydate = Paymonth.new(paymonth_params)
   binding.pry
   if @paydate.save
      flash[:success] = "New paymonth has been created"
      redirect_to paymonths_url
   else
      flash[:danger] = @paydate.errors.full_messages
      redirect_to new_paymonth_path
    end
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
