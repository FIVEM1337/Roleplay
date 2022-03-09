let callnumber
var outgoingsound = null;
var messagesound = null;
var bmessagesound = null;
var incomingsound = null;
var mutes = false;
callstatus = null
callnumber = null



$(document).on('click', '.phone-enter', function() {
    let number = $(this).data('id');

    var element = document.getElementById("phone-number-enter");
    element.innerHTML = element.innerHTML + number;

    $("#phone-enter-deletelast").fadeIn(250);
});


$(document).on('click', '#phone-enter-deletelast', function() {
    let number = $(this).data('id');

    $("#phone-number-enter").html($("#phone-number-enter").text().replace(/.$/g, ''));

    if ($('#phone-number-enter').text().trim() === "") {
        $("#phone-enter-deletelast").fadeOut(250);
    }
});


$(document).on('click', '.phone-enter-call', function() {
    callnumber = $('#phone-number-enter').text()
    callstatus = "outgoing"
    var number = document.getElementById("phone-number-enter");
    var element = document.getElementById("phone-call-outgoing-caller");
    element.innerHTML = number.innerHTML;
    $(".phone-call").hide();
    $(".phone-call-app").show();
    $(".phone-call-outgoing").fadeIn(250);

    if (mutes == true) {
        if (locale == "de") {
            sendData("notification", { text: localede.yourecallingsb, length: 5000 })
        } else {
            sendData("notification", { text: locale.yourecallingsb, length: 5000 })
        }
    } else {
        if (outgoingsound != null) {
            outgoingsound.pause();
        }

        outgoingsound = outgoingsoundfile
        outgoingsound.volume = soundvolume;
        outgoingsound.currentTime = 0;
        outgoingsound.loop = true;
        outgoingsound.play();
    }

    sendData("startcall", { number: callnumber });
});


$(document).on('click', '#outgoing-cancel', function() {
    $(".phone-call").fadeIn(250);
    $(".phone-call-app").hide();
    $(".phone-call-outgoing").hide();
    sendData("stopcall")
    outgoingsound.pause();
    callstatus = null
    callnumber = null
});

function IncomingCall(number, contact) {
    CloseAll();
    $(".phone-call-app").show();
    $(".phone-call-incoming").fadeIn();

    var element = document.getElementById("phone-call-incoming-caller");

    element.innerHTML = contact;

    if (mutes == true) {
        if (locale == "de") {
            sendData("notification", { text: localede.somebodyiscallingyou, length: 5000 })
        } else {
            sendData("notification", { text: locale.somebodyiscallingyou, length: 5000 })
        }
    } else {

        incomingsound = null

        if (incomingsound != null) {
            incomingsound.pause();
        }

        incomingsound = incomingsoundfile
        incomingsound.volume = soundvolume;
        incomingsound.currentTime = 0;
        incomingsound.loop = true;
        incomingsound.play();
    }
}

$(document).on('click', '#incoming-answer', function() {
    sendData("acceptcall")

});

$(document).on('click', '#incoming-deny', function() {
    $(".phone-applications").fadeIn(250);
    $(".phone-call-app").hide();
    $(".phone-call-incoming").hide();

    sendData("declinecall")
    incomingsound.pause();
});

function Autodecline() {
    $(".phone-applications").fadeIn(250);
    $(".phone-call-app").hide();
    $(".phone-call-incoming").hide();

    sendData("declinecall")
    incomingsound.pause();
}

incall = false

function AcceptCall(number, contact) {
    $(".phone-call-outgoing").hide();
    $(".phone-call-incoming").hide();
    $(".phone-call-app").show();
    $(".phone-call-ongoing").fadeIn(250);
    $(".phone-homebar").fadeIn(250);
    if (outgoingsound != null) {
        outgoingsound.pause();
    };
    if (incomingsound != null) {
        incomingsound.pause()
    };
    incall = true
    callstatus = "incall"
    callnumber = contact
    var element = document.getElementById("phone-call-ongoing-caller");
    element.innerHTML = contact;

    let seconds = 0
    let minutes = 0

    var Timer = setInterval(() => {
        var element = document.getElementById("phone-call-ongoing-time");

        if (seconds == 60) {
            minutes = minutes + 1
            seconds = 0
        } else {
            seconds = seconds + 1
        }

        if (seconds < 10) {
            if (minutes < 10) {
                element.innerHTML = '0' + minutes + ':0' + seconds;
            } else {
                element.innerHTML = minutes + ':0' + seconds;
            }
        } else {
            if (minutes < 10) {
                element.innerHTML = '0' + minutes + ':' + seconds;
            } else {
                element.innerHTML = minutes + ':' + seconds;
            }
        }

        if (incall == false) {
            element.innerHTML = '00:00';
            clearInterval(Timer);
        }
    }, 1000);
}

$(document).on('click', '#ongoing-cancel', function() {
    sendData("endcall")
});


function EndCall() {
    CloseAll();
    $(".phone-applications").fadeIn(250);
    callstatus = null
    callnumber = null
    incall = false
    $(".bigincallsymbol").fadeOut(500)
    $(".incallsymbol").fadeOut(200)
}

function EndCallHome() {
    callstatus = null
    callnumber = null
    incall = false
    $(".bigincallsymbol").fadeOut(500)
    $(".incallsymbol").fadeOut(200)
}

function DeclineCall() {
    CloseAll();
    $(".phone-applications").fadeIn(250);
    sendData("stopcall")

    if (outgoingsound != null) {
        outgoingsound.pause();
    };
    if (incomingsound != null) {
        incomingsound.pause()
    };
}

function StopCall() {
    CloseAll();
    $(".phone-applications").fadeIn(250);
    $(".bigincallsymbol").fadeOut(500)
    $(".incallsymbol").fadeOut(200)
    callstatus = null
    callnumber = null
    if (outgoingsound != null) {
        outgoingsound.pause();
    };
    if (incomingsound != null) {
        incomingsound.pause()
    };
}

function StopCallHome() {
    $(".bigincallsymbol").fadeOut(500)
    $(".incallsymbol").fadeOut(200)
    callstatus = null
    callnumber = null
    if (outgoingsound != null) {
        outgoingsound.pause();
    };
    if (incomingsound != null) {
        incomingsound.pause()
    };
}

$(document).on('click', '#pcb-numpad', function() {
    $(".phone-all-call-sector").hide();
    $(".phone-call-sector").fadeIn(250);
});

$(document).on('click', '#pcb-calls', function() {
    sendData("loadrecentcalls")
});

$(document).on('click', '#pacs-call', function() {
    var number = $(this).data('number');
    callnumber = number
    callstatus = "outgoing"
    var element = document.getElementById("phone-call-outgoing-caller");
    element.innerHTML = number;
    CloseAll();
    $(".phone-call-app").show();
    $(".phone-call-outgoing").fadeIn(250);
    selectednumber = number;
    if (mutes == true) {
        if (locale == "de") {
            sendData("notification", { text: localede.yourecallingsb, length: 5000 })
        } else {
            sendData("notification", { text: locale.yourecallingsb, length: 5000 })
        }
    } else {
        if (outgoingsound != null) {
            outgoingsound.pause();
        }

        outgoingsound = outgoingsoundfile
        outgoingsound.volume = soundvolume;
        outgoingsound.currentTime = 0;
        outgoingsound.loop = true;
        outgoingsound.play();
    }
    sendData("startcall", { number: number });
});

$(document).on('click', '#pacs-message', function() {
    var number = $('#pacs-call').data('number');;

    sendData("loadmessage", {
        number: number
    });
    selectednumber = number;
    lastcontact = 'message'
});

function loadrecentcalls(html) {
    $(".phone-all-call-sector").children().detach();
    $(".phone-all-call-sector").append(html);

    $(".phone-call-sector").hide();
    $(".phone-all-call-sector").fadeIn(250);

    if (darkmode == true) {
        Darkmode();
    }
}

$(document).on('click', '#headerminimize', function() {
    $(".left60").hide(500)
    $(".left40").hide(500)
    $(".bigincallsymbol").animate({
        position: "absolute",
        width: "4vh",
        "height": "4vh",
        "line-height": "4vh",
        "text-align": "center",
        "top": "4.5vh",
        "left": "80%",
        "background-color": "rgba(167, 204, 137, 0.8)",
        "border-radius": "3vh",
    }, 500)
    $(".bigincallsymbol").fadeOut(500)
    $(".incallsymbol").show(500)
    // $("#startmining").animate({top: '12vh', "border-color": "rgb(223, 45, 45)"}, 500);
})

$(document).on('click', '#headermaximize', function() {
    if (callstatus == "ongoing") {
        CloseAll()
        $(".phone-call-app").show();
        $(".phone-call-outgoing").fadeIn(250);
        $(".bigincallsymbol").fadeOut(250)
        $(".phone-homebar").fadeIn(250);
    } else if (callstatus == "incall") {
        CloseAll()
        $(".phone-call-app").show();
        $(".phone-call-ongoing").fadeIn(250);
        $(".bigincallsymbol").fadeOut(250)
        $(".phone-homebar").fadeIn(250);
    }
})

$(document).on('click', '#headerendcall', function() {
    if (callstatus == "ongoing") {
        sendData("stopcall")
        StopCallHome()
    } else if (callstatus == "incall") {
        sendData("endcall")
        EndCallHome()
    }
})

$(document).on('click', '.incallsymbol', function() {
    $(".left60").hide(0)
    $(".left40").hide(0)
    $(".bigincallsymbol").animate({
        position: "absolute",
        width: "4vh",
        "height": "4vh",
        "line-height": "4vh",
        "text-align": "center",
        "top": "4.5vh",
        "left": "80%",
        "background-color": "rgba(167, 204, 137, 0.8)",
        "border-radius": "3vh",
    }, 0)

    $(".bigincallsymbol").fadeIn(500)
    $(".incallsymbol").fadeOut(200)

    $(".bigincallsymbol").animate({
        "position": "absolute",
        "width": "90%",
        "height": "5vh",
        "top": "5vh",
        "left": "5%",
        "border-radius": "1vh",
        "background-color": "rgba(255, 255, 255, 0.9)",
    }, 500)

    setTimeout(function(){
        $(".left60").show(0)
        $(".left40").show(0)
    }, 500)
})

$(document).on('click', '#phone-call-historydiv', function() {
    var name = $(this).data('name');
    var number = $(this).data('number');
    var time = $(this).data('time');

    selectednumber = number
    selectedname = name
    // $("#phone-app-contact").hide(0)
    
    $("#phone-app-call-history-contact-name").html(name)
    $("#phone-app-call-history-contact-number").html(number)
    $("#phone-app-call-history-contact-time").html(time)



    currentpage = "#phone-app-call-history-contact"
    lastpage = "#phone-call"
    canback = true

    
    AppSlideIn(currentpage, lastpage)


});

$(document).on('click', '#phone-app-contact-page-addtocontacts', function() {
    prepage = "#phone-call"
    currentpage = "#phone-app-contact-new"
    lastpage = "#phone-app-call-history-contact"

    var number = selectednumber

    $('#phone-app-contact-phonenumber').val(number)
    AppSlideIn(currentpage, lastpage)
});