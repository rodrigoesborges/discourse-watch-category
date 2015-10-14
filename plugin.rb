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

# *start* ANNOUNCEMENTS watched by NAMATI_STAFF
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
# *end* ANNOUNCEMENTS

# *start* LEADERSHIP watched by NAMATI_LEADERSHIP
    leadership_category = Category.find_by_slug("leadership")
    namati_leadership_group = Group.find_by_name("namati_leadership")
    return if leadership_category.nil? || namati_leadership_group.nil?

    namati_leadership_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], leadership_category.id) unless watched_categories.include?(leadership_category.id)
    end
# *end* LEADERSHIP

# *start* NGC watched by NETWORK_LEADERSHIP 
    ngc_category = Category.find_by_slug("ngc")
    network_ngc_group = Group.find_by_name("network_ngc")
    return if ngc_category.nil? || ngc_group.nil?

    network_ngc_group.users.each do |user|
      watched_categories = CategoryUser.lookup(user, :watching).pluck(:category_id)
      CategoryUser.set_notification_level_for_category(user, CategoryUser.notification_levels[:watching], ngc_category.id) unless watched_categories.include?(ngc_category.id)
    end
# *end* NGC

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
