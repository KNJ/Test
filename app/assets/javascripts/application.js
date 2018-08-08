//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require turbolinks
//= require nested_form_fields
//= require flatpickr

//flatpickrの初期化
flatpickr('#SearchCalendar';
// flatpickr('#EventCalendar');
// $('#SearchCalendar').flatpickr();

// //flatpickrの初期化
// flatpickr('#EventCalendar',config

// $(function() {
//   var elems = getDOMElements();
//   var today = new Date();
//   var calendar = null;

//   Flatpickr.l10ns.default.weekdays.shorthand = [
//     "日", "月", "火", "水", "木", "金", "土"
//   ];

//   calendar = new Flatpickr(elems.flatpickr, {
//     "enableTime": true,
//     "defaultDate": today
//   });

//   function getDOMElements() {
//     return {
//       "flatpickr": document.getElementById("flatpickr")
//     };
//   }
// })
// ();

//■page topボタン
$(function () {
    var topBtn = $('#pageTop');
    topBtn.hide();
    //◇ボタンの表示設定
    $(window).scroll(function () {
        if ($(this).scrollTop() > 80) {
            //---- 画面を80pxスクロールしたら、ボタンを表示する
            topBtn.fadeIn();
        } else {
            //---- 画面が80pxより上なら、ボタンを表示しない
            topBtn.fadeOut();
        }
    });
    // ◇ボタンをクリックしたら、スクロールして上に戻る
    topBtn.click(function () {
        $('body,html').animate({
            scrollTop: 0
        }, 500);
        return false;
    });
});