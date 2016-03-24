# frozen_string_literal: true
# name: Watch Category
# about: Watches a category for all the users in a particular group
# version: 0.3
# authors: Jared Needell

module ::WatchCategory
  def watch_by_group(category_slug, group_name)
    category = Category.find_by(slug: category_slug)
    group = Group.find_by_name(group_name)
    return if category.nil? || group.nil?

    group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], category.id) unless watched_categories.include?(category.id)
    end
  end

  def watch_all(category_slug)
    category = Category.find_by(slug: category_slug)
    User.all.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], category.id) unless watched_categories.include?(category.id)
    end 
  end

  def self.watch_category!
    WatchCategory.watch_by_group("confidential-employees-only", "EmployeesOnly")
    WatchCategory.watch_by_group("facilities-us","Morrisville")
    WatchCategory.watch_by_group("facilities-us","Seattle")
    WatchCategory.watch_by_group("facilities-happenings","RemoteUS")
    WatchCategory.watch_by_group("facilities-uk","London")

    WatchCategory.watch_all("company-announcements")
    WatchCategory.watch_all("Corporate-Scheduled-Maintenance")
    WatchCategory.watch_all("Corporate-System-Status")
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
