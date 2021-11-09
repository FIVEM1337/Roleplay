var oldwallpaper = null

$(document).on('click', '#changewallpaper', function() {
    $(".phone-settings-sector").hide(500)
    // $(".phone-homebar").hide(500)
    $(".phone-settings-inner").show(500)
    lastwindow = "wallpaper"
    $("#headerback").show(500)
    
});

$(document).on('click', '#viewbackground', function() {
    var wallpaper = $(this).parent().data("wallpaper");
    var oldwallpaper2 =  $('.phone-background').css('background-image');
    oldwallpaper = oldwallpaper2.replace('url(','').replace(')','').replace(/\"/gi, "");
    Wallpaperpreview(wallpaper)
});

$(document).on('click', '#viewcustombackground', function() {
    var wallpaper = $("#customwallpaper").val()
    var oldwallpaper2 =  $('.phone-background').css('background-image');
    oldwallpaper = oldwallpaper2.replace('url(','').replace(')','').replace(/\"/gi, "");
    Wallpaperpreview(wallpaper)
});

function Wallpaperpreview(wallpaper) {
    $(".phone-settings").hide(500)
    $(".phone-homebar").hide(500)
    $(".wallpaperpreviewclose").show(500)
    ChangeWallpaper(wallpaper);
}

$(document).on('click', '.wallpaperpreviewcloseicon', function() {
    $(".phone-homebar").show(500)
    $(".phone-settings").show(500)
    $(".wallpaperpreviewclose").hide(500)
    ChangeWallpaper(oldwallpaper);
});

$(document).on('click', '#setbackground', function() {
    var wallpaper = $(this).parent().data("wallpaper");

    sendData("changewallpaper", {
        url: wallpaper
    });
});


$(document).on('click', '#custombackground', function() {
    var wallpaper = $("#customwallpaper").val();

    sendData("changewallpaper", {
        url: wallpaper
    });
});

function openSettings(html) {
    $(".phone-applications").hide();
    $(".phone-settings").show(500)
    $("#phone-homebar").show(500)

    $(".phone-settings-inner").children().detach();
    $(".phone-settings-inner").append(html);

    if (darkmode == true) {
        Darkmode();
    }
}