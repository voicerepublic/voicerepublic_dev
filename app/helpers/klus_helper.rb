module KlusHelper
  
  def bookmark_links(user, klu)
    #puts user.inspect
    #return nil if user.new_record?
    if user && (klu.user != user) &! klu.user.nil?
      if Bookmark.bookmarked?(user.id, klu.id)
        link_to(t('.remove_from_bookmarks'), user_bookmark_path(:user_id => user, :id => Bookmark.bookmark_for(user.id, klu.id).id), :method => :delete, :class => "btn btn-small")
      else
        link_to(t('.add_bookmark'), create_bookmark_path(:klu_id => klu), :method => :post, :class => "btn btn-small")
      end
    end
  end
  
  # renders the corresponding form for STI-model type Kluuu or NoKluuu
  #
  def form_for_klu(klu)
    klu.instance_of?(Kluuu) ? render(:partial => 'klus/form_kluuu') : render(:partial => 'klus/form_no_kluuu')
  end
  
  def medium_partial_for_klu(klu)
    klu.instance_of?(Kluuu) ? render(:partial => 'klus/medium_kluuu', :locals => {:medium_kluuu => klu }) : render(:partial => 'klus/medium_no_kluuu', :locals => { :medium_no_kluuu => klu })
  end
  
end
