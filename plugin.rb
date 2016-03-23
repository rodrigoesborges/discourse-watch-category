# frozen_string_literal: true
# name: Watch Category
# about: Watches a category for all the users in a particular group
# version: 0.3.1

module ::WatchCategory
  def self.watch_category!
    confidential_category = Category.find_by_slug("confidential-employees-only")
    channeladvisor_employee_group = Group.find_by_name("EmployeesOnly")
    return if confidential_category.nil? || channeladvisor_employee_group.nil?

    channeladvisor_employee_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], confidential_category.id) unless watched_categories.include?(confidential_category.id)
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
