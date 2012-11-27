require 'active_record'
require 'pathname'
require 'fileutils'

module Upgrade

  require 'active_record'

  ActiveRecord::Base.configurations["kluuu1"] = {
    :adapter  => 'postgresql',
    :database => 'kluuu_production',
    :username => 'kluuu',
    :password => 'foobar',
    :host     => 'localhost'
  }

  ActiveRecord::Base.configurations["kluuu2"] = {
    :adapter  => 'postgresql',
    :database => 'kluuu2_development',
    :username => 'kluuu2',
    :password => 'foobar',
    :host     => 'localhost'
  }

  class UserOld < ActiveRecord::Base
    establish_connection "kluuu1"
    set_table_name 'users'

    has_attached_file :portrait, :url => "/system/migration/portraits/:id/:style/:filename"
    has_many :offers, :foreign_key => :user_id
    has_many :auth_providers, :foreign_key => :user_id
    has_one :account, :class_name => 'OldAccount', :foreign_key => :user_id
  end

  class AuthProvider < ActiveRecord::Base
    establish_connection "kluuu1"
    belongs_to :user, :class_name => 'UserOld', :foreign_key => :user_id
  end

  class Tag < ActiveRecord::Base
    establish_connection "kluuu1"
    has_many :taggings, :foreign_key => :tag_id
  end

  class Tagging < ActiveRecord::Base
    establish_connection "kluuu1"
    belongs_to :offer, :foreign_key => :taggable_id
    belongs_to :tag, :foreign_key => :tag_id
  end

  class OldAccount < ActiveRecord::Base
    establish_connection "kluuu1"
    set_table_name  'accounts'

    belongs_to :user, :class_name => 'UserOld', :foreign_key => :user_id
  end

  class Offer < ActiveRecord::Base
    establish_connection "kluuu1"
    has_attached_file :image, :url => "/system/migration/images/:id/:style/:filename"

    has_many :taggings, :foreign_key => :taggable_id
    belongs_to :user, :foreign_key => :user_id, :class_name => 'UserOld'
    has_many :assignments
    has_many :offer_categories, :through => :assignments
  end

  class OfferCategory < ActiveRecord::Base
    establish_connection "kluuu1"
    has_many :assignments
    has_many :offers, :through => :assignments
  end

  class Assignment < ActiveRecord::Base
    establish_connection "kluuu1"
    belongs_to :offer_category
    belongs_to :offer
  end

  module Migrate
    class Runner

      CHARGE_TYPES = { 1 => 'free', 2 => 'minute', 3 => 'fix'}
      SECTORS = { 1 => "personal experience", 2 => "professional", 3 => "interest" }

      def migrate_users
        start_time = Time.now
        UserOld.all.each do |old_usr|
          puts "processing old user: #{old_usr.id}"

          f_name = if old_usr.user_name
            old_usr.user_name.length < 2 ? old_usr.email.split("@")[0] : old_usr.user_name
          else
            old_usr.email.split("@")[0]
          end
          l_name = if old_usr.user_surname
            old_usr.user_surname.length < 2 ? old_usr.email.split("@")[0] : old_usr.user_surname
          else
            old_usr.email.split("@")[0]
          end

          user = User.new( :firstname => f_name, :lastname => l_name, :email => old_usr.email, :encrypted_password => old_usr.password_digest )

          unless old_usr.auth_providers.empty?
          prov = old_usr.auth_providers.first
          user.uid = prov.uid
          user.provider = prov.provider
          end

          user.save(:validate => false)

          begin
            add_account(user,old_usr)

            check_for_portrait(user,old_usr)

            add_balance_account(user, old_usr)
            migrate_offers(user,old_usr)

          rescue Exception => e
            puts "ERROR: #{e.to_s}"
            raise
          end
        end
        elapsed_time = Time.now - start_time
        puts "migration took #{elapsed_time}"
        nil
      end

      def finishing
        touch_all_migrated_user()
      end

      private

      def check_for_portrait(user, old_usr)
        if old_usr.portrait_file_name && old_usr.portrait_file_name.length > 2
          test_path = Pathname.new(old_usr.portrait.path)
          if test_path.exist?
            user.account.update_attributes!(:portrait_file_name => old_usr.portrait_file_name,
            :portrait_content_type => old_usr.portrait_content_type,
            :portrait_file_size => old_usr.portrait_file_size)
            copy_portrait(user,old_usr)
          else
            puts "PROBLEM with: portrait path: #{test_path} does not exist - ignoring"
          end
        end
      end

      def add_account(user,old_usr)
        user.account.update_attributes!(:about => old_usr.user_desc,
        :language_1 => old_usr.user_lang_0)
        user
      end

      def add_balance_account(user, old_usr)
        unless old_usr.account.nil?
          user.create_balance_account!(:currency => ( old_usr.account.currency || "EUR"), :balance_cents => old_usr.account.balance_amount, :revenue_cents => old_usr.account.revenue_amount )
        user
        end
      end

      def migrate_offers(user, old_usr)
        old_usr.offers.each do |offer|

          if offer.public
            t_list = offer.offer_categories.map { |x| [x.name, (Upgrade::OfferCategory.find(x.parent_id).name if x.parent_id) ] }.join(",")

            unless offer.taggings.empty?
              t_list = t_list + "," + offer.taggings.map { |tgs| tgs.tag.name }.join(",")
            end

            if offer.image_file_name && offer.image_file_name.length > 2
              klu = user.kluuus.create!(:title => offer.title,
              :description => offer.description,
              :charge_type => CHARGE_TYPES[offer.tariff_type],
              :charge_cents => offer.charge_amount || 0,
              :published => true,
              :tag_list => t_list,
              :category => Category.first
              )
              k_image = klu.klu_images.create!(:image_file_name => offer.image_file_name, :image_content_type => offer.image_content_type, :image_file_size => offer.image_file_size)
              copy_image(k_image,offer)
            # TODO: get portrait and move it
            else
              user.no_kluuus.create!(:title => offer.title,
              :description => offer.description,
              :charge_type => 'free',
              :charge_cents => 0,
              :published => true,
              :tag_list => t_list,
              :category => Category.first
            )
            end
          end

        end

      end

      def copy_portrait(user, old_user)
        dest = Pathname.new(user.account.portrait.path)
        orig = Pathname.new(old_user.portrait.path)

        if orig.exist?
          dest.dirname.mkpath
          FileUtils.cp(orig.to_s, dest.dirname.to_s )
        else
          puts "NO PORTRAIT FOR: #{orig}"
        end
      end

      def copy_image(k_image, old_offer)
        dest = Pathname.new(k_image.image.path)
        orig = Pathname.new(old_offer.image.path)
        if orig.exist?
          dest.dirname.mkpath
          FileUtils.cp(orig.to_s, dest.dirname.to_s )
        else
          puts "NO IMAGE FOR: #{orig}"
        end
      end

      def touch_all_migrated_user
        User.all.each do |user|
          user.save
        end
      end

    end

  end

end