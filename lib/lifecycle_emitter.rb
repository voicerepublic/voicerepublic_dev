# Complete list of ActiveRecord callbacks
#
# * after_initialize
# * after_find
# * after_touch
# * before_validation
# * after_validation
# * before_save
# * around_save
# * after_save
# * before_create
# * around_create
# * after_create
# * before_update
# * around_update
# * after_update
# * before_destroy
# * around_destroy
# * after_destroy
# * after_commit
# * after_rollback
#
# from http://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html
#
module LifecycleEmitter

  extend ActiveSupport::Concern

  included do
    after_create -> { emit(:create) }
    after_destroy -> { emit(:destroy) }
  end

  def emit(event)
    type = self.class.name.underscore.to_sym
    Emitter.lifecycle(type, self, event)
  end

end
