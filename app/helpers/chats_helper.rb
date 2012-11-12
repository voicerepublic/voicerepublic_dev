module ChatsHelper
  
  def user_for_chat(chat, user)
    chat.user1 == user ? chat.user2 : chat.user1
  end
  
end
