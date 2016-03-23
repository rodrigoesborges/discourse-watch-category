# frozen_string_literal: true
# name: Watch Category
# about: Watches a category for all the users in a particular group
# version: 0.3.1

module ::WatchCategory
  def self.watch_by_group(category_slug, group_name)
    category = Category.find_by(slug: category_slug)
    group = Group.find_by_name(group_name)
    return if category.nil? || group.nil?
  def self.watch_category!
    confidential_category = Category.find_by_slug("confidential-employees-only")
    channeladvisor_employee_group = Group.find_by_name("EmployeesOnly")
    return if confidential_category.nil? || channeladvisor_employee_group.nil?

    group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], category.id) unless watched_categories.include?(category.id) || user.staged
    end
  end

  def self.watch_all(category_slug)
    category = Category.find_by(slug: category_slug)
    User.all.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], category.id) unless watched_categories.include?(category.id)  || user.staged
    end 
  end

  def self.watch_category!
    
    WatchCategory.watch_by_group("capitulo-brasil","capitulo_brasil")
   # WatchCategory.watch_by_group("ProdNotifications","Engineering")

   # Example to watch by all users  WatchCategory.watch_all("Corporate-System-Status")
    namati_staff_group.users.each do |user|
    channeladvisor_employee_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], confidential_category.id) unless watched_categories.include?(confidential_category.id)
    end
    
    thepit_category = Category.find_by_slug("the-pit")
    everyone_group = Group.find_by_name("everyone")
    return if thepit_category.nil? || everyone_group.nil?

    everyone_group.users.each do |user|
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
