# TODO cleanup! is anything of this used?
module UsersHelper
  def spanify(name)
    ('<span>' + name.gsub(' ','</span><span>&nbsp;') + '</span>').html_safe
  end
end
