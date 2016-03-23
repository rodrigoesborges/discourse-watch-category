# frozen_string_literal: true
# name: Watch Category
# about: Watches a category for all the users in a particular group
# version: 0.3

module ::WatchCategory
  def self.watch_category!
    announcements_category = Category.find_by_slug("confidential-employees-only")
    namati_staff_group = Group.find_by_name("EmployeesOnly")
    return if announcements_category.nil? || namati_staff_group.nil?

    namati_staff_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], announcements_category.id) unless watched_categories.include?(announcements_category.id)
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
