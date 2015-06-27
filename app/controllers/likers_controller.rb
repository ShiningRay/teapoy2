class LikersController < ApplicationController
  respond_to :html

  def index
    @likers = scope.all
    respond_with(@likers)
  end

  def create
    @like = story.likes.new(liker_params)
    @like.save
    respond_with(@like.user)
  end

  def destroy
    story.likes.where(:user_id => params[:id]).delete_all
    respond_with story, location: [guestbook, story, :likers]
  end

  private
    def set_liker
      @liker = scope.find(params[:id])
    end

    def story
      @story ||= guestbook.stories.find params[:story_id]
    end

    def guestbook
      @guestbook ||= Guestbook.find params[:guestbook_id]
    end

    def scope
      story.likers
    end

    def liker_params
      params.require(:liker).permit(:user_id)
    end
end
