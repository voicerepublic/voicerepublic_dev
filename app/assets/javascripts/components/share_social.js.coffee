attribute = '#social_share .share'

initialize = (element, selector) ->
  source = $(element)
  target = $(selector)

  $(source).click ->

    # returns either ["facebook"] or ["twitter"]
    social_network = $(element).attr("class").split(" ").filter (data) ->
      data unless data is "share"
    social_network = social_network[0]

    # url that the respective social network uses for sharing
    social_url = {
      facebook: "https://www.facebook.com/sharer/sharer.php?u="
      twitter: "https://twitter.com/intent/tweet?source=webclient&text="
    }[social_network]

    social_url += encodeURI(window.location)

    $.post("/api/social_shares",
      social_share:
        shareable_id: $(element).attr("data-shareable-id")
        shareable_type: $(element).attr("data-shareable-type")
        social_network: social_network
    ).always((data) ->
      window.open(social_url, "_blank").focus()
      return
    )


$("#{attribute}").each (index, element) ->
  value = $($(element).attr(attribute))
  initialize element, value
  console.log(element)
