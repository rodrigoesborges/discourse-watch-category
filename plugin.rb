# frozen_string_literal: true
# name: Watch Category
# about: Watches a category for all the users in a particular group
# version: 1.0
# authors: Jared Needell

module ::WatchCategory
<<<<<<< HEAD
  def self.watch_by_group(category_slug, group_name)
    category = Category.find_by(slug: category_slug)
    group = Group.find_by_name(group_name)
    return if category.nil? || group.nil?
=======
  def self.watch_category!
    announcements_category = Category.find_by_slug("announcements")
    namati_staff_group = Group.find_by_name("namati_staff")
    return if announcements_category.nil? || namati_staff_group.nil?
>>>>>>> 2b6ceca (added indication for start/end for each category)

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

    culture_category = Category.find_by_slug("culture")
    namati_culture_group = Group.find_by_name("namati_culture")
    return if culture_category.nil? || namati_culture_group.nil?

    namati_culture_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], culture_category.id) unless watched_categories.include?(culture_category.id)
    end

    visionoutcome_category = Category.find_by_slug("visionoutcome")
    namati_visionoutcome_group = Group.find_by_name("namati_visionoutcome")
    return if visionoutcome_category.nil? || namati_visionoutcome_group.nil?

    namati_visionoutcome_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], visionoutcome_category.id) unless watched_categories.include?(visionoutcome_category.id)
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
