$ ->

  # bootstrap
  $('.button.prev').hide()
  $('section:first').addClass('current')

  isMobile = false
  if( /Android|webOS|iPhone|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) )
    isMobile = true

  # mobile menu
  toggle = $('#mobileMenu .button.toggle')
  close = $('#mobileMenu .button.close')

  toggle.click ->
    $(this).hide()
    $('#menu').animate { left: 0 }, 250, ->
      close.fadeIn(250)

  close.click ->
    $(this).hide()
    $('#menu').animate { left: $(window).width() }, 250, ->
      toggle.fadeIn(250)

  # regular menu
  # $('#menu a').click ->
  $('#header a').click ->
    if isMobile
      close.trigger 'click'
    to = $(this).attr('class')
    to = $('section.'+to)
    scrollToSection(to)
    return false

  $('#pager .page').click ->
    p = $(this)
    n = p.prevAll().length
    to = $('section').eq(n)
    scrollToSection(to)
    return false

  scrollToSection = (to) ->
    to = to.offset()
    if isMobile
      to = to.top
      scrollPos = $(window).scrollTop()
    else
      to = to.left
      scrollPos = $(window).scrollLeft()
    time = to - scrollPos
    if time < 0
      time = time * -1
    time = time / 5
    if isMobile
      $('html, body').animate({ 'scrollTop': ( to - $('header').height() ) }, (time*1.5), 'easeInOutQuad')
    else
      $('html, body').animate({ 'scrollLeft': to }, time, 'easeInOutQuad')





  # previous / next arrows
  isScrolling = false
  $('#arrows .button').click ->
    if(! isScrolling )
      if $(this).hasClass('prev')
        nav('prev')
      else
        nav('next')
  nav = (dir) ->
    winW = $(window).width()
    scrolld = $(window).scrollLeft()
    if dir == 'prev'
      to = scrolld - winW
    if dir == 'next'
      to = scrolld + winW
    isScrolling = true
    $('html, body').animate { 'scrollLeft': to }, 500, 'easeInOutQuad', ->
      isScrolling = false
      return

  if isMobile
    debounceTime = 500
  else
    debounceTime = 20

  $(window).bind 'scroll', $.debounce debounceTime, ->

    if isMobile
      scrolld = $(window).scrollTop() - $(window).height()
      total = $(document).height()
    else
      scrolld = $(window).scrollLeft()
      total = $(document).width() - $(window).width()

    # show and hide next/prev at the start and end
    if scrolld <= 0 && $('.button.prev').is(':visible')
      $('.button.prev').fadeOut(500)
    if scrolld > 0 && $('.button.prev').is(':hidden')
      $('.button.prev').fadeIn(500)
    if scrolld >= total && $('.button.next').is(':visible')
      $('.button.next').fadeOut(500)
    if scrolld < total && $('.button.next').is(':hidden')
      $('.button.next').fadeIn(500)

    # check which section is closest to scrolld
    section = $('section:first')
    $('.section').each ->
      position = $(this).offset()
      if isMobile
        position = position.top
      else
        position = position.left
      # console.log 'position: ' + position + '\nscrolld: ' + scrolld
      if scrolld <= position
        section = $(this)
        sn = section.prevAll().length
        # console.log 'current section # ' + sn
        return false

    # add current class to section
    $('section').not(section).removeClass('current')
    section.addClass 'current'

    # add current color to menu
    currentColor = section.data('color')
    $('header').removeClass('red').removeClass('yellow').removeClass('green').removeClass('purple').removeClass('lightblue').addClass(currentColor)

    # update underline in menu
    if section.hasClass('waypoint')
      waypoint = section.data('waypoint')
      $('#menu a').removeClass('current')
      $('#menu a.'+waypoint).addClass('current')
      if waypoint == 'a0'
        $('#menu a').removeClass('current')

    # update pager
    sectionN = section.prevAll().length
    $('.page').removeClass('current')
    $('.page:eq("' + sectionN + '")').addClass('current')

    return
    # end scroll bind


  # re-center current section if window is resized
  $(window).smartresize ->
    to = $('section.current').offset()
    to = to.left
    $('html, body').animate { 'scrollLeft': to }, 500, 'easeInOutQuad'
    return
