# coding: utf-8
class TicketsController < ApplicationController
  before_filter :login_required
  before_filter :active_user_required
  def submit
    @group = Group.find_by_alias params[:group_id]
    topics = @group.topics.pending.includes(:top_post, :user).page(params[:page]||1)
     if topics.size > 0
      pending_queue=topics.collect{|i|i.id}
      if pending_queue.size > 60
        pending_queue = pending_queue[0,60].shuffle + pending_queue[60..-1]
      else
        pending_queue.shuffle!
      end
      @submitted = get_submitted(pending_queue)
      @rest_queue = pending_queue - @submitted

      if @rest_queue.size > 0
        f = @rest_queue.shift
        topic = Topic.find(f)
        @comments = topic.comments.find :all, :order => "id asc"
        #        @tickets = {}
        #        @topic.tickets.each do |t |
        #          @tickets[t.ticket_type_id.to_i] ||= 0
        #          @tickets[t.ticket_type_id.to_i] += 1
        #        end
        @group = topic.group
        @ticket = Ticket.new(:topic_id => topic.id, :viewed_at => Time.now)
        c = current_user.tickets.count
        if c != 0 && c % 30 == 0
          flash[:notice]="感谢您的辛勤劳动，我们已将您的人品+1"
        end
      end
    end
    render :layout => false
  end

  # GET /tickets
  # GET /tickets.xml
  def index
    @tickets = current_user.tickets.page(params[:page]||1)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @tickets }
      format.json { render :json => @tickets }
    end
  end

  # GET /tickets/1
  # GET /tickets/1.xml
  def show
    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ticket }
    end
  end

  # GET /tickets/new
  # GET /tickets/new.xml
  def new
    topic = Topic.find params[:topic_id]
    @ticket = Ticket.where(:topic_id => topic.id, :user_id => current_user.id).first
    return render :text => '你已投过票' if @ticket
    @ticket = Ticket.new :topic_id => topic.id
    @ticket_types = TicketType.where('weight < 0')

    respond_to do |format|
      format.html { render :layout => false}
      format.xml  { render :xml => @ticket }
    end
  end

  # GET /tickets/1/edit
  def edit
    @ticket = Ticket.find(params[:id])
  end

  # POST /tickets
  # POST /tickets.xml
  def create

    @ticket = Ticket.new params[:ticket]
    if @ticket.ticket_type_id == 0
      @ticket.ticket_type_id = nil
    else
      if @ticket.ticket_type and @ticket.ticket_type.weight > 0
        d, s = :up, 1
      else
        d, s = :down, -1
      end
    end
    @ticket.user_id = current_user.id

    topic=@ticket.topic
    if topic.comment_status != 'closed' and params[:content]
      comment = Comment.new(
        :content => params[:content],
        :user_id => current_user.id,
        :topic_id => topic.id,
        :ip => request.remote_ip,
        :anonymous => params[:anonymous]||false,
        :status => 'publish'
      )
      comment.content.strip!
      #current_user.has_favorite @topic

      topic.comments << comment
    end
    successful = true
    duplicate = false

    begin
      @ticket.save!
    rescue ActiveRecord::StatementInvalid => e
      if e.message.index('Duplicate')
        duplicate = true
      else
        successful = false
      end
    end

    respond_to do |format|
      if successful
        unless duplicate
          TicketWorker.check @ticket.topic_id
          #          submitted = get_submitted
          #          submitted << @ticket.topic_id
          if d and s
            ScoreWorker.vote(:action => d, :id => @ticket.topic_id)
            current_user.rate(@ticket.topic_id, s)
          end
        end
        if session[:submitted]
          session[:submitted] << " #{@ticket.topic_id}"
        end

        format.mobile do
          if request.xhr?
            render :text => '$("#new_ticket").replaceWith("投票成功")'
          else
            flash[:notice] = 'Ticket was successfully created.'
            redirect_to(submit_tickets_path)
          end
        end
        format.xml  { render :xml => @ticket, :status => :created, :location => @ticket }
      else
        format.html { render :new }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tickets/1
  # PUT /tickets/1.xml
  def update
    @ticket = Ticket.find(params[:id])

    respond_to do |format|
      if @ticket.update_attributes(params[:ticket])
        flash[:notice] = 'Ticket was successfully updated.'
        format.html { redirect_to(@ticket) }
        format.xml  { head :ok }
      else
        format.html { render :edit }
        format.xml  { render :xml => @ticket.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.xml
  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy

    respond_to do |format|
      format.html { redirect_to(tickets_url) }
      format.xml  { head :ok }
    end
  end
  protected
  def get_submitted(pending_queue)
    if session[:submitted]
      submitted=session[:submitted].split(' ').collect{|i|i.to_i}
    else
      submitted = current_user.tickets.find :all, :conditions => ['topic_id >= ? and topic_id <= ?',pending_queue.min, pending_queue.max], :select => 'topic_id'
      submitted.collect!{|i|i.topic_id}
      session[:submitted] = submitted.join(' ')
    end
    submitted
  end
  def active_user_required
    return redirect_to('/') unless current_user.state == 'active'
  end
end
