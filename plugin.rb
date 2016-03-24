# name: Watch Category
# about: Watches a category for all the users in a particular group
# version: 0.3
# authors: Jared Needell

module ::WatchCategory
  def self.watch_category!
    announcements_category = Category.find_by(slug: "confidential-employees-only")
    employee_staff_group = Group.find_by_name("EmployeesOnly")
    return if announcements_category.nil? || employee_staff_group.nil?

    employee_staff_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], announcements_category.id) unless watched_categories.include?(announcements_category.id)
    end

    thepit_category = Category.find_by(slug: "the-pit")

    User.all.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], thepit_category.id) unless watched_categories.include?(thepit_category.id)
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
