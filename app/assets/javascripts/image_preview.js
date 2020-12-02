$(document).on('turbolinks:load', function () {
  $(function(){
    //fileが選択された時に発火するイベント
    $('#img-file').change(function(){
      //選択したfileのオブジェクトをpropで取得
      var file = $('input[type="file"]').prop('files')[0];
      //FileReaderのreadAsDataURLで指定したFileオブジェクトを読み込む
      var fileReader = new FileReader();
      //読み込みが完了すると、srcにfileのURLを格納
      fileReader.onloadend = function() {
        var src = fileReader.result;
        var html= `<div class='image'>
                     <div class=' image-content'>
                        <img src=${src} width="250" height="200" >
                     </div>
                     <div class='image-operetion'>
                       <div class='image-operetion-delete btn btn-danger'>削除</div>
                     </div>
                   </div>`;
        //img-file要素の前にhtmlを差し込む
        $('#img-file').before(html);
        $('#img-edit').remove()
        //プレビューがあったらフォームを隠す
        var count = $('.image').length;
        if (count == 1) {
          $('#img-file').hide();
        }
      };
      fileReader.readAsDataURL(file);
    });
  });
});

$(document).on("click", '.image-operetion-delete', function(){
  //プレビュー要素を取得
  var target_image = $(this).parent().parent()
  //プレビューを削除
  target_image.remove();
  //inputタグに入ったファイルを削除
  $('#img-file').val("")
  // フォームを戻す
  $('#img-file').show();
})