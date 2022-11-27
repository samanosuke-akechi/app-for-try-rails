import 'slick-carousel';

$(window).on("load", function() {
  // スライドを形作るのに最低限必要なのは$(セレクタ).slick({})
  // スライダーにしたいHTMLの親要素のクラスまたはIDをセレクタにする
  // {}の中に必要とするオプションを書く
  $('.your-class').slick({
    centerMode: true,
    autoplay: true,
    zIndex: 10000,
    dots: true,
    centerPadding: '60px',
    slidesToShow: 1,
    focusOnSelect: true,
    responsive: [
      {
        breakpoint: 768,
        settings: {
          arrows: false,
          centerMode: true,
          centerPadding: '40px',
          slidesToShow: 3
        }
      },
      {
        breakpoint: 480,
        settings: {
          arrows: false,
          centerMode: true,
          centerPadding: '40px',
          slidesToShow: 1
        }
      }
    ],
    // スライド左右操作の見た目を変えるオプション
    // それぞれclass="slick-prev"とclass="slick-next"は必ず必要
    prevArrow: '<img src="https://nureyon.com/sample/64/arrow-1-p9.svg?2020-11-13" class="slick-prev" alt="arrow">',
    nextArrow: '<img src="https://nureyon.com/sample/64/arrow-1-p56.svg?2020-11-13" class="slick-next" alt="arrow">'
  });
})
