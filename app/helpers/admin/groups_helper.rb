# coding: utf-8
module Admin::GroupsHelper
  def options_check_box obj, field, label
    checked = "checked='check'" if @group.options[field.to_sym]
   out = ""
   out << "<input type='hidden' name=\"group[options][#{field}]\" value=\"no\" />"
   out << "<label><input type='checkbox' name=\"group[options][#{field}]\" value=\"yes\" #{checked} />"
   out.html_safe
  end


  def options_check_box_for_preference obj, field, label=nil
    text = label || field
    checked = "checked='check'" if @group.options[field]
    out=""
    out << "<input type='hidden' name=\"group[options_attributes][#{field}]\" value='false'/>"
    out << "<label class='checkbox'>"
    out << "<input type='checkbox' name=\"group[options_attributes][#{field}]\" value='true' #{checked} />"
    out << "#{text}</label>"
    out.html_safe
  end
end
