# Browserify entry point for the global.js bundle (yay CoffeeScript!)
$ = require 'jquery'
Masonry = require 'masonry-layout'
imagesLoaded = require 'imagesloaded'
Flickity = require 'flickity'
$ ->

  $('.js-home').on 'click', (e) ->
    e.preventDefault()
    $('.l-section').removeClass('is-open').removeClass('is-closed').animate {scrollTop: 0},200
    $('html,body').animate {scrollTop: 0}, 200
  $('.js-about').on 'click', (e) ->
    e.preventDefault()
    $('html, body').animate
      scrollTop: $(".about").offset().top - 100
    , 400
  $('.js-contact').on 'click', (e) ->
    e.preventDefault()
    $('html, body').animate
      scrollTop: $(".contact").offset().top
  startMasonry = =>
    $('.js-projects').each (index) ->
      if msnryProducts == undefined && msnryGrafic == undefined
        container = $(this).get(0)
        $container = $(this)
        if index == 0
          msnryProducts = new Masonry(container,
            itemSelector: '.card'
            percentPosition: true
            margin: 50
            isOriginLeft: false
            columnWidth: 50)
          imagesLoaded( $container, msnryProducts.layout() )
          msnryProducts.layout()
          $('.js-section').on 'click', =>
            console.log msnryProducts
            setTimeout =>
              msnryProducts.layout()
            , 1000
        else
          msnryGrafic = new Masonry(container,
            itemSelector: '.card'
            percentPosition: true
            margin: 50
            isOriginLeft: false
            columnWidth: 50
          )
          imagesLoaded( $container, msnryGrafic.layout() )
          msnryGrafic.layout()
          $('.js-section').on 'click', =>
            setTimeout ->
              msnryGrafic.layout()
            , 1000

  startMasonry()
  # layoutMasonry = =>
  #   $('.js-projects').each (index) =>
  #     container = $(this).get(0)
      # msnry.layout()
  # Loads project into new div
  # scoped with .project-id


  removeProject = ->
    $('.project').removeClass('is-visible')
    setTimeout ->
      $('.project').remove()
    , 400

  $('.js-card').on 'click', (e) ->
    
    $card = $(this)

    # pass attributes
    id = $card.attr('data-id')
    type = $card.attr('data-type')
    # creates container with classname
    newproject = document.createElement 'div'
    newproject.className = 'project-' + id + ' project-' + type + ' project'
    $('body').append newproject

    # interpoaltes ad lceans url
    url = window.location.href + '/' + type + '/' + id + '.html'
    url = url.replace '#', ''

    $('.project-' + id).load url, (res, status) ->
      if status == 'success'
        flkty = new Flickity '.gallery',
          imagesLoaded: true
          pageDots: false
          wrapAround: true
          prevNextButtons: false
        $('.js-gallery-left').on 'click', ->
          flkty.previous()
        $('.js-gallery-right').on 'click', ->
          flkty.next()
        $('.js-project-close').on 'click', ->
          removeProject()
        setTimeout ->
          # console.log ($(window).height() - $('.project-' + id).height()) / 2
          # top = $(window).height() / 2 - $('.project-' + id).outerHeight() + 80
          top = 100
          $('.project-' + id).css top: top + 'px'
          $('.project-' + id).addClass 'is-visible'
        , 200


  toggleSection = ($this, that) ->
    if $this.hasClass 'is-open'
      $('html,body').animate {scrollTop: 0}, 200
      if $('.project').length
        $('.project').removeClass 'is-visible'
      return
    else if $('.l-section-' + that).hasClass 'is-open'
      removeProject()
      setTimeout ->
        $('html,body').animate {scrollTop: 0}, 200
        top = $('.l-section-' + that).scrollTop()
        timeStep = top * 0.1
        $('.l-section-' + that).animate {scrollTop: 0}, timeStep
        setTimeout ->
          $this.addClass('is-open').removeClass 'is-closed'
          $this.one('click')
          $('.l-section-' + that).addClass('is-closed').removeClass 'is-open'
        , timeStep
      ,400
    else
      $this.addClass('is-open').removeClass 'is-closed'
      $('html,body').animate {scrollTop: 0}, 200
      $('.l-section-' + that).addClass('is-closed').removeClass 'is-open'


  # Kinda dirty, manages section

  $('.js-section').on 'click', (e) ->

    # NICE 
   
    $this = $(this)
    if $this.hasClass 'l-section-left'

      toggleSection($(this), 'right')
    else
      toggleSection($(this), 'left')



  $('.js-section').hover (e) ->
    if $(this).hasClass 'l-section-left'
      $(this).addClass('is-hover').removeClass 'is-notHover'
      $('.l-section-right').addClass('is-notHover').removeClass 'is-hover'
    else
      $(this).addClass('is-hover').removeClass 'is-notHover'
      $('.l-section-left').addClass('is-notHover').removeClass 'is-hover'
  , (e) ->
    if $(this).hasClass 'l-section-left'
      $(this).removeClass 'is-hover'
      $('.l-section-right').removeClass 'is-notHover'
    else
      $(this).removeClass 'is-hover'
      $('.l-section-left').removeClass 'is-notHover'
