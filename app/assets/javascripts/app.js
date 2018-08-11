$(function () {
    // 検索時にカレンダ入力
    $('.SearchCalendar').flatpickr({
        locale: {
            firstDayOfWeek: 1,
            weekdays: {
                shorthand: ['日', '月', '火', '水', '木', '金', '土'],
            },
            months: {
                longhand: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
            },
        },
        minDate: "today",
        disableMobile: "true"
    });
    // 「開演日時」のフォームをカレンダ入力
    $('#EventStart').flatpickr({ enableTime: true, defaultHour: 19, time_24hr: true,
    locale: {
            firstDayOfWeek: 1,
            weekdays: {
                shorthand: ['日','月', '火', '水', '木', '金', '土'],
            },
            months: {
                longhand: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
            },
        },
        minDate: "today",
        disableMobile: "true"
     });
    // 「一般発売開始」のフォームをカレンダ入力
     $('#GeneralSaleStart').flatpickr({ enableTime: true, defaultHour: 10, time_24hr: true,
        locale: {
            firstDayOfWeek: 1,
            weekdays: {
                shorthand: ['日', '月', '火', '水', '木', '金', '土'],
            },
            months: {
                longhand: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
            },
        },
        minDate: "today",
        disableMobile: "true"
     });
    // 「先行販売開始」のフォームをカレンダ入力
     $('#PreSaleStart').flatpickr({ enableTime: true, defaultHour: 12, time_24hr: true,
        locale: {
            firstDayOfWeek: 1,
            weekdays: {
                shorthand: ['日', '月', '火', '水', '木', '金', '土'],
            },
            months: {
                longhand: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
            },
        },
        minDate: "today",
        disableMobile: "true"
     });
    // 「先行販売終了」のフォームをカレンダ入力
     $('#PreSaleEnd').flatpickr({ enableTime: true, defaultHour: 18, time_24hr: true,
        locale: {
            firstDayOfWeek: 1,
            weekdays: {
                shorthand: ['日', '月', '火', '水', '木', '金', '土'],
            },
            months: {
                longhand: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
            },
        },
        minDate: "today",
        disableMobile: "true"
     });    
    //TOPに戻るボタン
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
function _submit() {
    $("#search_event_by_date").submit();
}