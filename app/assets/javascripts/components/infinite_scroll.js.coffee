# the attribute takes 3 arguments spearated by pipe
#
# * spy - a css selector, pointing to the node that triggers
#   loading when scrolled into view
#
# * target - a css selector, pointing to node that holds the results
#
# * pager - a css selector, pointing to the node the holds the
#   paging information
#
attribute = 'data-infinite-scroll'

initialize = (node, value) ->

  [ spy, target, pager ] = value.split('|')

  loading = false # use to debounce
  page = 1

  $(window).scroll ->

    return if loading

    top = $(window).scrollTop()
    bottom = top + $(window).height()

    pos = $(spy).offset().top

    if pos <= bottom && pos >= top
      loading = true
      page = parseInt($(pager).val())
      page = page + 1
      $(pager).val(page)
      query = $(node).serialize()+'&page='+page
      url = window.location.pathname+'?'+query
      NProgress.start()
      $.ajax url,
        success: (data) ->
          $(target).append(data)
          NProgress.done()
          loading = false
          if !data.trim()
            $(spy).remove()
            loading = true

$("*[#{attribute}]").each (index, element) ->
  value = $(element).attr(attribute)
  initialize element, value
