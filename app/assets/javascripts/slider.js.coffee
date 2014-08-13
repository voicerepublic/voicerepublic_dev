$ ->
  $(".user-talks-slider").slick
    slide: "li"
    dots: true
    infinite: false
    speed: 300
    slidesToShow: 3
    slidesToScroll: 3
    arrows: false
    responsive: [
      {
        breakpoint: 700
        settings:
          slidesToShow: 2
          slidesToScroll: 2
      }
      {
        breakpoint: 480
        settings:
          slidesToShow: 1
          slidesToScroll: 1
      }
    ]
