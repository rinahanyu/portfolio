$(document).on('turbolinks:load', function () {
  $(function() {
    $('.menu-trigger').on('click', function(event) {
      $(this).toggleClass('active');
      $('#sp-menu').fadeToggle();
      event.preventDefault();
    });
  });
});