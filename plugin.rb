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

    ngc_category = Category.find_by_slug("ngc")
    network_ngc_group = Group.find_by_name("network_ngc")
    return if ngc_category.nil? || network_ngc_group.nil?

    network_ngc_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], ngc_category.id) unless watched_categories.include?(ngc_category.id)
    end

    culture-systems_category = Category.find_by_slug("culture-systems")
    namati_culture_group = Group.find_by_name("namati_culture")
    return if culture-systems_category.nil? || namati_culture_group.nil?

    namati_culture_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], culture-systems_category.id) unless watched_categories.include?(culture-systems_category.id)
    end

    vision-outcome_category = Category.find_by_slug("vision-outcome")
    namati_visionoutcome_group = Group.find_by_name("namati_visionoutcome")
    return if vision-outcome_category.nil? || namati_visionoutcome_group.nil?

    namati_visionoutcome_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], vision-outcome_category.id) unless watched_categories.include?(vision-outcome_category.id)
    end  

    assessingopp_category = Category.find_by_slug("assessingopp")
    namati_assessingopp_group = Group.find_by_name("namati_assessingopp")
    return if assessingopp_category.nil? || namati_assessingopp_group.nil?

    namati_assessingopp_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], assessingopp_category.id) unless watched_categories.include?(assessingopp_category.id)
    end

    scale_category = Category.find_by_slug("scale")
    namati_scale_group = Group.find_by_name("namati_scale")
    return if scale_category.nil? || namati_scale_group.nil?

    namati_scale_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], scale_category.id) unless watched_categories.include?(scale_category.id)
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
