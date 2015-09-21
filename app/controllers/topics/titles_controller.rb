class Topics::TitlesController < ApplicationController
  before_action :set_topic
  before_action :login_required

  def update
    if current_user == @topic.user
      @topic.title = params[:value]
      @topic.save
    end
    respond_with(@topic)
  end


  private
    def topics_title_params
      params[:topics_title]
    end

    def set_topic
      @topic = Topic.find params[:topic_id]
    end
end
