class GigsController < ApplicationController

  respond_to :html
  
  before_filter :fetch_chapters
  before_filter :fetch_gig, :only => [:show, :attend, :attending]
  before_filter :authenticate_user!, :only => [:attend, :attending]

	def index
	  @chapter = Chapter.find_by_title(params[:chapter]) if params[:chapter]
	  @gigs = (@chapter) ? Gig.find_all_by_chapter_id(@chapter.id) : Gig.all
	end

	def show
	  @attendees = @gig.users
    @attendees = @gig.users.where("user_id != #{current_user.id}") if user_signed_in?
	end
	
	def attend

    location = gig_path(@gig)

	  if @gig.users.include?(current_user)
	    slot = current_user.slots.select { |item| item.gig_id == @gig.id }.first	    
      slot.users.delete(current_user)
      flash[:notice] = "You are no longer attending this gig."
    else
      slot = (params[:slot].nil?) ? @gig.slots.first : Slot.find(params[:slot])
      if slot.limit && (slot.users.count >= slot.limit &&  slot.limit > 0)
        flash[:error] = "Sorry, we've reached the limit for this slot."
      else
        slot.users << current_user
        location =  attending_gig_path(@gig)
      end
    end
  
    redirect_to location
    
	end
	
	def attending
	end
	
	private
	  def fetch_chapters
      @chapters = Chapter.all
	  end
	  
	  def fetch_gig
	    @gig = Gig.find(params[:id])
	  end

end