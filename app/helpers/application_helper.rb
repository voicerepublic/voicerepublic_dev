module ApplicationHelper
  
  # limit number of words beeing displayed.
  #
  def limit_words(txt, num)
    arr = txt.split(" ")
    if arr.length > num-1
      arr[0..num-1].join(" ").concat(" ...")
    else
      txt
    end
  end
  
end
