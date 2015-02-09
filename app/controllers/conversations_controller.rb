class ConversationsController < ApplicationController
  before_action :set_conversation, only: [:show, :edit, :update, :destroy]

  def index
    @conversations = scope.latest.page(params[:page])
    respond_with(@conversations)
  end

  def show
    @messages = @conversation.messages.latest.page(params[:page])
    @messages.read!
    respond_with(@conversation)
  end

  def new
    @conversation = scope.new
    respond_with(@conversation)
  end

  def create
    p = conversation_params.merge({owner_id: current_user.id})
    @conversation = scope.where(p).first || scope.new(p)
    @conversation.save
    respond_with @conversation
  end

  def destroy
    @conversation.destroy
    respond_with(@conversation)
  end

  private
    def scope
      @scope ||= current_user.conversations
    end

    def set_conversation
      @conversation = scope.find(params[:id])
    end

    def conversation_params
      params.require(:conversation).permit(:target_id)
    end
end
