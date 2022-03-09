var oldwallpaper = null

oldcase = null
oldmodel = null

$(function() {
    window.addEventListener("message", function(event) {
        var v = event.data;

        if (v.ReloadWallpaper == true) {
            ReloadWallpaper(v.html)
        } else if (v.ReloadCases == true) {
            ReloadCases(v.html)
        } else if (v.setRingtone == true ) {
            incomingsoundfile = new Audio(v.ringtone);
        }
    });
});

function ReloadWallpaper(html) {
    $("#phone-app-settings-bg-inner").children().detach();
    $("#phone-app-settings-bg-inner").append(html);

    if (darkmode == true) {
        Darkmode();
    }

    form19 = document.getElementById('customwallpaper');

    form19.addEventListener('mousedown', (event) => {
        sendData("SetNuiFocusKeepInputFalse")
    }, true);
    
    form19.addEventListener('focus', (event) => {
        sendData("SetNuiFocusKeepInputFalse")
    }, true);
      
      form19.addEventListener('blur', (event) => {
        sendData("SetNuiFocusKeepInputTrue")
      }, true);
}

function ReloadCases(html) {
    $("#phone-app-settings-case-inner").children().detach();
    $("#phone-app-settings-case-inner").append(html);

    if (darkmode == true) {
        Darkmode();
    }
}

$(document).on('click', '#changewallpaper', function() {
    // $(".phone-settings-sector").hide(500)
    // // $(".phone-homebar").hide(500)
    // $(".phone-settings-inner").show(500)
    // lastwindow = "wallpaper"
    // $("#headerback").show(500)

    $(".phone-settings-inner").show(0)

    currentpage = "#phone-app-settings-bgchange"
    lastpage = "#phone-app-settings"
    canback = true

    AppSlideIn(currentpage, lastpage)
});

$(document).on('click', '#changecase', function() {
    $(".phone-settings-inner").show(0)
    currentpage = "#phone-app-settings-casechange"
    lastpage = "#phone-app-settings"
    canback = true

    lastwindow = "case"
    AppSlideIn(currentpage, lastpage)
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
    $("#phone-app-settings-bgchange").hide(500)
    $(".phone-homebar").hide(500)
    $(".wallpaperpreviewclose").show(500)
    ChangeWallpaper(wallpaper);
}

$(document).on('click', '.wallpaperpreviewcloseicon', function() {
    $(".phone-homebar").show(500)
    $("#phone-app-settings-bgchange").show(500)
    $(".wallpaperpreviewclose").hide(500)
    ChangeWallpaper(oldwallpaper);
});

$(document).on('click', '#setbackground', function() {
    var wallpaper = $(this).parent().data("wallpaper");
    sendData("changewallpaper", {
        url: wallpaper
    });
    sendData("ReloadWallpaper")
});


$(document).on('click', '#custombackground', function() {
    var wallpaper = $("#customwallpaper").val();

    sendData("changewallpaper", {
        url: wallpaper
    });
    sendData("ReloadWallpaper")
});

function openSettings(html, casehtml) {
    CloseAll()
    $(".phone-applications").hide();
    $("#phone-app-settings").show(500)
    $("#phone-homebar").show(500)

    $("#phone-app-settings-bg-inner").children().detach();
    $("#phone-app-settings-bg-inner").append(html);

    $("#phone-app-settings-case-inner").children().detach();
    $("#phone-app-settings-case-inner").append(casehtml);

    if (darkmode == true) {
        Darkmode();
    }

    form19 = document.getElementById('customwallpaper');

    form19.addEventListener('mousedown', (event) => {
        sendData("SetNuiFocusKeepInputFalse")
    }, true);
    
    form19.addEventListener('focus', (event) => {
        sendData("SetNuiFocusKeepInputFalse")
    }, true);
      
      form19.addEventListener('blur', (event) => {
        sendData("SetNuiFocusKeepInputTrue")
      }, true);
}

$(document).on('click', '#viewcase', function() {
    var cas = $(this).parent().data("case");
    var model = $(this).parent().data("model");

    Casepreview(cas, model)
});

$(document).on('click', '#setcase', function() {
    var cas = $(this).parent().data("case");
    var model = $(this).parent().data("model");

    Casepreview(cas, model, true)
});

function Casepreview(cas, model, save) {
    $(".phone-frame").attr("src",cas);
    if (model == "samsung") {
        $("#phone-time").css({
            "font-size": "1.5vh",
            "padding": "2.3vh 0 0 1.9vh",
        })
        $("#phone-icons").css({
            "font-size": "0.95vh",
            "padding": "2.5vh 7.5vh 0 0vh",
        })
        $("#phone-battery").css({
            "top": "0vh",
            "position": "relative",
            "font-size": "2vh",
        })
    } else {
        $("#phone-time").css({
            "font-size": "1.5vh",
            "padding": "2vh 0 0 3vh",
        })
        $("#phone-icons").css({
            "font-size": "0.95vh",
            "padding": "2vh 3vh 0 0vh",
        })
        $("#phone-battery").css({
            "top": "0vh",
            "position": "relative",
            "font-size": "2vh",
        })
    }

    if (save == true) {
        sendData("changecase", {
            case: cas,
            model: model
        });
        sendData("ReloadCases")
        oldcase = cas
        oldmodel = model
    } else {
        oldcase = "./img/model1.png"
        oldmodel = "iphone"
    }
}


function LoadRingtones(html) {
    $("#phone-app-settings-ringtones-inner").children().detach();
    $("#phone-app-settings-ringtones-inner").append(html);
    sendData("print", {message: "TESt2"})
}

$(document).on('click', '#changeringtone', function() {
    $(".phone-settings-inner").show(0)

    currentpage = "#phone-app-settings-ringtonechange"
    lastpage = "#phone-app-settings"
    canback = true

    AppSlideIn(currentpage, lastpage)
});


var soundtest = null
var PlaySound = "null"
var lastsound = null

$(document).on('click', '#viewringtone', function() {
    if (PlaySound == 'null') {
        var path = $(this).parent().data("ringtone");
        soundtest = new Audio(path)
        soundtest.volume = 0.2;
        soundtest.loop = true;
        soundtest.currentTime = 0;
        soundtest.play();
        PlaySound = 'true'

        lastsound = $(this)
        $(this).removeClass('fa-bell')
        $(this).addClass('fa-bell-slash')

    } else if (PlaySound == 'true') {
        lastsound.removeClass('fa-bell-slash')
        lastsound.addClass('fa-bell')
        soundtest.pause();
        PlaySound = 'null'
    }
});

$(document).on('click', '#setringtone', function() {
    var ringtone = $(this).parent().data("ringtone");

    sendData("changeringtone", {
        url: ringtone
    });
    incomingsoundfile = new Audio(ringtone);
});

$(document).on('click', '#viewcustomringtone', function() {
    var ringtone = $('#customringtone').val()
    if (PlaySound == 'null') {
        var path = ringtone
        soundtest = new Audio(path)
        soundtest.volume = 0.2;
        soundtest.loop = true;
        soundtest.currentTime = 0;
        soundtest.play();
        PlaySound = 'true'

        lastsound = $(this)
        $(this).removeClass('fa-bell')
        $(this).addClass('fa-bell-slash')

    } else if (PlaySound == 'true') {
        lastsound.removeClass('fa-bell-slash')
        lastsound.addClass('fa-bell')
        soundtest.pause();
        PlaySound = 'null'
    }
});

$(document).on('click', '#setcustomringtone', function() {
    var ringtone = $('#customringtone').val()

    sendData("changeringtone", {
        url: ringtone
    });
    incomingsoundfile = new Audio(ringtone);
});
