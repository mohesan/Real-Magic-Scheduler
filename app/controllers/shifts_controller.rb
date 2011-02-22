class ShiftsController < ApplicationController
  include ShiftsHelper
  before_filter :authenticate
  before_filter :admin, :only => [:new, :create, :drop_primary, :drop_secondary, :edit, :update]
  
  def index
    @title = "Shifts"
    @shifts = admin? ? Shift.all : Shift.current
  end
  
  def show
    @shift = Shift.find params[:id]
    @title = @shift.name
  end
  
  def new
    @title = "New Shift"
    @shift = Shift.new
  end
  
  def create
		@shift = Shift.new(params[:shift])
		if @shift.save
			flash[:success] = "Shift created successfully!"
			redirect_to shifts_path
		else
			@title = "New Shift"
			render 'new'
		end
	end
	
	def edit
	  @title = "Edit shift"
	  @shift = Shift.find params[:id]
	end
	
	def update
	  @shift = Shift.find params[:id]
		if @shift.update_attributes(params[:shift])
			flash[:success] = "Shift updated."
			redirect_to shifts_path
		else
			@title = "Edit shift"
			render 'edit'
		end
	end
	
	def destroy 
	  shift = Shift.find params[:id]
	  shift.delete
	  flash[:success] = "#{shift.name} deleted."
	  redirect_to shifts_path
	end
	
	def secondary
	  shift = Shift.find(params[:id])
	  if can_secondary?(shift)
	    shift.secondary = current_user
	    shift.save
	    flash[:success] = "You are now the secondary for #{shift.name}"
	  else
	    flash[:error] = "There was a problem processing your request. If this problem continues please contact the scheduler."
	  end
	  redirect_to shifts_path
	end
	
	def primary
	  shift = Shift.find(params[:id])
	  if can_primary?(shift)
	    shift.primary = current_user
	    shift.save
	    flash[:success] = "You are now the primary for #{shift.name}"
	  else
	    flash[:error] = "There was a problem processing your request. If this problem continues please contact the scheduler."
	  end
	  redirect_to shifts_path
	end
	
	def drop_primary
	  shift = Shift.find(params[:id])
	  shift.primary = nil
	  shift.save
	  redirect_to shifts_path
	end
	
	def drop_secondary
	  shift = Shift.find(params[:id])
	  shift.secondary = nil
	  shift.save
	  redirect_to shifts_path
	end
end
