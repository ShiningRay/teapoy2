# coding: utf-8
#TODO: change it to SettingsController
class Admin::KeywordsController < Admin::BaseController
  # GET /keywords
  # GET /keywords.xml
  def index
    @replacelist = Setting['replacelist'].to_a.collect{|i| i.join(' ')}.join("\r\n") if Setting['replacelist']
    #@replacelist = Setting['replacelist'].to_s
    @blacklist = Setting['blacklist'].join("\r\n") if Setting['blacklist']
  end

  # PUT /keywords/1
  # PUT /keywords/1.xml
  def update
    words = params['replacelist'].split(/\s+/)
    words << '?' if words.length.odd? #ensure even-number length to make a hash
    replacelist = Hash[*words]
    Setting['replacelist'] = replacelist
    Setting['blacklist'] = params['blacklist'].split(/[\r\n]+/)
    redirect_to :controller => 'admin/keywords', :action => :index
  end

  # DELETE /keywords/1
  # DELETE /keywords/1.xml
  def destroy
    @keyword = Keyword.find(params[:id])
    @keyword.destroy

    respond_to do |format|
      format.html { redirect_to(keywords_url) }
      format.xml  { head :ok }
    end
  end
end
