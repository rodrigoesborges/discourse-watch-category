# name: Watch Category
# about: Watches a category for all the users in a particular group
# version: 0.2
# authors: Arpit Jalan
# url: https://github.com/discourse/discourse-watch-category-mcneel

module ::WatchCategory
  def self.watch_category!
    announcements_category = Category.find_by_slug("announcements")
    namati_staff_group = Group.find_by_name("namati_staff")
    return if announcements_category.nil? || namati_staff_group.nil?

    namati_staff_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], announcements_category.id) unless watched_categories.include?(announcements_category.id)
    end

    leadership_category = Category.find_by_slug("leadership")
    namati_leadership_group = Group.find_by_name("namati_leadership")
    return if leadership_category.nil? || namati_leadership_group.nil?

    namati_leadership_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], leadership_category.id) unless watched_categories.include?(leadership_category.id)
    end
  end
end

after_initialize do
  module ::WatchCategory
    class WatchCategoryJob < ::Jobs::Scheduled
      every 1.day

      def execute(args)
        WatchCategory.watch_category!
      end
    end
  end
end
