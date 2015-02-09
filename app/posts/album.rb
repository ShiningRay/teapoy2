# coding: utf-8
class Album < Post
  field :cover
  validates_each :list_items do |model, attr, val|
    val.each do |item|
      unless item.is_a?(Picture) or item.is_a?(Album)
        model.errors.add(attr, 'must be Picture or Album')
        break
      end
    end
  end
end
