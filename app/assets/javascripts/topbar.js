if (insider) {
    console.log("loading topbar.");
}

var $searchLoupe = $('#search-loupe a')
var $searchContainer = $('.search-container')
var $canHide = $('.can-hide')

TweenMax.set($searchContainer,{right:"-800px", autoAlpha:0, display: "none"})

var showSearchContainer = function(){
    TweenMax.to($searchContainer, .5, {autoAlpha: 1, right: 0, display: "block",ease: Power2.easeOut})
    TweenMax.to($searchLoupe, .5, {autoAlpha: 0, scaleX: 0, scaleY: 0})
    TweenMax.to($canHide, .5, {autoAlpha: 0, scaleX: 0, scaleY: 0})
}

var hideSearchContainer = function(){
    TweenMax.to($searchContainer, .5, {autoAlpha: 0, right: "-800px", display: "none",ease: Power2.easeOut})
    TweenMax.to($searchLoupe, .5, {autoAlpha: 1, scaleX: 1, scaleY: 1})
    TweenMax.to($canHide, .5, {autoAlpha: 1, scaleX: 1, scaleY: 1})
}

$('#search-loupe a').on('click',function(){
    showSearchContainer()
    $('#mobile-nav').hide();
});

$('#search-close').on('click', function(){
    hideSearchContainer()
});