# This is a dirty hack to fix Draper problem with kaminari
# Put this in app/decorators/collection_decorator.rb
class Draper::CollectionDecorator

    delegate :current_page, :total_pages, :limit_value, :entry_name, :offset_value, :last_page?

    def total_count
      source.total_count
    end

end