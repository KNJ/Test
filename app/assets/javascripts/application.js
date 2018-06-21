//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require flatpickr/l10n/da

// flatpickrを起動させるinputのID *classでも可
// 当日以前の日付は表示させない

//flatpickrの初期化
flatpickr('#EventCalendar');

//jQueryでflatpickrを使用
//$("#EventCalendar").flatpickr(altInput: true,altFormat: "F j, Y",dateFormat: "Y-m-d");

 var toJPN = {
               weekdays : ['日', '月', '火', '水', '木', '金', '土'],
               months: ['1月', '2月', '3月', '4月', '5月', '6月', '7月',
                         '8月', '9月', '10月', '11月', '12月'
                       ]
              };

// '曜日'を日本語化
//flatpickr.init.prototype.l10n.weekdays.shorthand = toJPN.weekdays;

// '月'を日本語化
//flatpickr.init.prototype.l10n.months.longhand = toJPN.months;

