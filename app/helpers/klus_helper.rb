module KlusHelper
  
  def bookmark_links(user, klu)
    #puts user.inspect
    #return nil if user.new_record?
    if user && (klu.user != user) &! klu.user.nil?
      if Bookmark.bookmarked?(user.id, klu.id)
        link_to(user_bookmark_path(:user_id => user, :id => Bookmark.bookmark_for(user.id, klu.id).id), :method => :delete) do
          content_tag('i', '', :class => 'icon-star').concat(content_tag(:span, t('.delete_bookmark')))
        end
      else
        link_to(create_bookmark_path(:klu_id => klu), :method => :post) do
          content_tag('i', '', :class => 'icon-star-empty').concat(content_tag(:span, t('.add_bookmark')))
        end
      end
    end
  end
  
  # renders the corresponding form for STI-model type Kluuu or NoKluuu
  #
  def form_for_klu(klu)
    klu.instance_of?(Kluuu) ? render(:partial => 'klus/form_kluuu') : render(:partial => 'klus/form_no_kluuu')
  end
  
  def small_partial_for_klu(klu)
    klu.instance_of?(Kluuu) ? render(:partial => 'klus/small_kluuu', :locals => {:small_kluuu => klu }) : render(:partial => 'klus/small_no_kluuu', :locals => { :small_no_kluuu => klu })
  end
  
end
