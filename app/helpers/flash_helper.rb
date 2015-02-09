module FlashHelper
  def render_flash
    render 'flashes' if can_flash?
  end

  def can_flash?
    flash.keys.sort == %w(from object_id object_type type)
  end

  def flash_object
    flash[:object_type].classify.constantize.where(id: flash[:object_id]).first
  end

  def flash_path
    File.join(controller_name, 'flashes', flash[:from].to_s, flash[:type].to_s)
  end
end
