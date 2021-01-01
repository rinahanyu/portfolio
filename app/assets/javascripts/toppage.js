$(document).on('turbolinks:load', function () {
  $(function(){
    $('#can-button').click(function(){
        $('#slide').slideToggle('slow');
        $(this).toggleClass('fa-rotate-180');
    });
  });
});
