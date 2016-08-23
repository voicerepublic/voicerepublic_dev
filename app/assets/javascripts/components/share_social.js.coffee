attribute = '#social_share .share'

initialize = (element, selector) ->
  #console.log "initialize: #{attribute} (#{selector})"

  source = $(element)
  target = $(selector)

  $(source).click ->

    # returns either ["facebook"] or ["twitter"]
    social_network = $(element).attr("class").split(" ").filter (data) ->
      data unless data is "share"
    social_network = social_network[0]

    $.post("/xhr/social_shares",
      authenticity_token: $('meta[name=csrf-token]')[0].content,
      social_share:
        shareable_id: $(element).attr("data-shareable-id")
        shareable_type: $(element).attr("data-shareable-type")
        social_network: social_network
    ).always((data) ->
      # share to fb/twitter. mail will open in a separate window anyway.
      unless social_network == 'mail'
        # url that the respective social network uses for sharing
        social_url = {
          facebook: "https://www.facebook.com/sharer/sharer.php?u="
          twitter: "https://twitter.com/intent/tweet?source=webclient&text="
        }[social_network]

        social_url += encodeURI(window.location)

        window.open(social_url, "_blank").focus()
      return
    )

# initializer
$("#{attribute}").each (index, element) ->
  value = $($(element).attr(attribute))
  initialize element, value
