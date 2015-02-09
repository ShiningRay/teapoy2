# coding: utf-8
class ChangePostsMetaFormat < ActiveRecord::Migration
  def up
    add_column :posts, :new_meta, :blob
    execute "UPDATE posts SET `meta` = NULL where `meta` like '--- {}%'"
    Post.select('id').order('id desc').where('meta is not null').find_each do |p|
      meta = connection.select_value("SELECT meta FROM posts WHERE id=#{p.id}")
      next unless meta
      next if meta.is_a?(String) and not meta =~ /^---/
      puts p.id
      puts meta
      v = YAML.load(meta)
      next if v.empty?
      v[:picture_updated_at] = v[:picture_updated_at].to_i if v[:picture_updated_at]
      hex = v.to_msgpack.unpack('H*')
      execute "UPDATE posts SET new_meta = 0x#{hex.first} WHERE id=#{p.id}" if hex.first.is_a?(String)
    end
    remove_column :posts, :meta
    remove_column :posts, :source
    remove_column :posts, :device
    rename_column :posts, :new_meta, :meta
  end

  def down
  end
end

