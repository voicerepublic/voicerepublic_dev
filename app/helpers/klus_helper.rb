module KlusHelper
  
  def bookmark_links(user, klu)
    if user 
      if Bookmark.bookmarked?(user.id, klu.id)
        link_to(t('.remove_from_bookmarks'), user_bookmark_path(:user_id => user, :id => Bookmark.bookmark_for(user.id, klu.id).id), :class => "btn btn-small")
      else
        link_to(t('.add_bookmark'), create_bookmark_path(:klu_id => klu), :method => :post, :class => "btn btn-small")
      end
    end
  end
  
end
