# coding: utf-8
module ArchivesHelper
  def group_archive_path(*args)
    options = args.extract_options!
    group, year, month, day = args
    group ||= options[:group_id] || options[:id]
    year ||= options[:year]
    month ||= options[:month]
    day ||= options[:day]
    month = sprintf("%02d", month) if month
    day = sprintf("%02d", day) if day
    id = (options[:date] || [year, month, day].compact.join('-'))

    url_for(:controller => 'archives', :action => 'show', :group_id => group.to_param, :id => id)
  end

  def archive_path(*args)
    args.unshift(@group)
    group_archive_path(*args)
  end

  def archives_path(*args)
    group_archives_path(*args)
  end
end
