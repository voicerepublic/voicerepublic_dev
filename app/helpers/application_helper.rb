module ApplicationHelper
  
  # limit number of words beeing displayed.
  #
  def limit_words(txt, num)
    arr = txt.split(" ")
    arr.length > num-1 ? arr[0..num-1].join(" ").concat(" ...") : txt
  end
  
end
