QB = {}
QB.Phone = {}
QB.Screen = {}
QB.Phone.Functions = {}
QB.Phone.Animations = {}
QB.Phone.Notifications = {}

let currentjob = 'null'
let businessicon = true
let servicesloaded = false
let backgroundurl = null
let darkbackgroundurl = null
let lastservicenumber = null
let darkmode = false;
let bankmoney = null
let alwayson = false

$(function() {
    var documentWidth = document.documentElement.clientWidth;
    var documentHeight = document.documentElement.clientHeight;
    var container = $(".container");

    window.addEventListener("message", function(event) {
        var item = event.data;

        if (item.showPhone) {
            QB.Phone.Animations.BottomSlideUp('.container', 300, 0);
            ChangeWallpaper(item.data.wallpaper);
            if (item.data.darkmode == 1) {
                Darkmode();
                darkmode = true
                document.getElementById("darkmodetoggle").checked = true;
            } else {
                Whitemode();
            }

            if (item.data.flightmode == 1) {
                $("#phone-flightmode").show();
                sendData("flightmode", { state: 1 });
                document.getElementById("flightmode").checked = true;
            } else {
                $("#phone-flightmode").hide();
                sendData("flightmode", { state: 0 });
                document.getElementById("flightmode").checked = false;
            }
            alwayson = item.alwayson
            $(".phone-message").hide();

            if (item.unemployed) {
                if (businessicon == true) {
                    $("#businessicon").remove();
                }
                businessicon = false
            }

            if (lastwindow == "privatmessage" && incall == false) {
                sendData("loadmessage", {
                    number: privatmessage
                });
            }
        } else if (item.hidePhone) {
            if (alwayson == false) {
                QB.Phone.Animations.BottomSlideDown('.container', 300, -70);
            } else {
                $(".container").animate({
                        "bottom": "-62vh",
                    })
            }
             
            // $(".container").animate({
            //     "bottom": "-62vh",
            // })
        } else if (item.hidePhoneInCall) {
            $(".container").animate({
                    "bottom": "-40vh",
                })
        } else if (item.OpenincomingCall) {
            $(".container").css({
                "bottom": "-70vh",
            })
            $(".container").show()
            $(".container").animate({
                "bottom": "-50vh",
            })
        } else if (item.CloseincomingCall) {
            $(".container").animate({
                "bottom": "-70vh",
            })
        } else if (item.loadBusiness) {
            loadBusiness(item.business)
        } else if (item.showContacts) {
            loadcontacts(item.html);
        } else if (item.showNotification) {
            ShowNotif(item);
        } else if (item.showMessages) {
            loadmessages(item.html, item.contactname)
        } else if (item.showRecentMessages) {
            if (item.recentmessagesopen == true) {
                reloadrecentmessages(item.html)
            } else {
                loadrecentmessages(item.html)
            }

         
        } else if (item.changeWallpaper) {
            ChangeWallpaper(item.url)
        } else if (item.acceptCall) {
            AcceptCall(item.number, item.contact)
        } else if (item.incomingCall) {
            IncomingCall(item.number, item.contact)
        } else if (item.endcall) {
            EndCall()
        } else if (item.declinecall) {
            DeclineCall()
        } else if (item.stopcall) {
            StopCall(item)
        } else if (item.loadrecentcalls) {
            loadrecentcalls(item.recentcalls)
        } else if (item.showBusiness) {
            showBusiness(item.member, item.onlinemember, item.motd)
        } else if (item.showRecentBusinessMessages) {
            loadrecentbusinessmessages(item.html)
        } else if (item.showBusinessMessages) {
            loadbusinessmessages(item.html, item.div)
        } else if (item.loadservices) {
            LoadServices(item.html)
        } else if (item.playmessagesound) {
            PlayMessageSound()
        } else if (item.playbusinessmessagesound) {
            PlayBMessageSound()
        } else if (item.updatetime) {
            UpdateTime(item)
        } else if (item.setvalues) {
            backgroundurl = item.backgroundurl;
            darkbackgroundurl = item.darkbackgroundurl;
        } else if (item.syncbpbabutton) {
            syncbpbabutton(item.number)
        } else if (item.syncclosebmessage) {
            syncclosebmessage(item.number)
        } else if (item.updatenumber) {
            $("#phonesettingsnumber").html(item.number);
        } else if (item.updatejobmoney) {
            businessmoney = item.businessmoney
            $("#pbms-money").html(item.businessmoney + "$");
        } else if (item.isboss) {
            $("#pbsjobmoney").html(locale.pbsjobmoney);
            $("#pbsboss").each(function() {
                $(this).show();
            });
        } else if (item.isntboss) {
            $("#pbsboss").each(function() {
                $(this).hide();
            });
        } else if (item.autodecline) {
            Autodecline()
        } else if (item.refreshmessages) {
            if (privatmessage == item.number) {
                refreshmessages(item.html, item.contactname)
            }
        } else if (item.refreshbusinessmessages) {
            reloadbusinessmessages(item.html, item.div)
        }  else if (item.enablesalty) {
            $("#phone-constant-radio").show()
        } else if (item.openSettings) {
            openSettings(item.html)
        }
    });

    $(document).keyup(function(data) {
        if (data.which == 27) {
            sendData("close");
        }
    });
});

function sendData(name, data) {
    $.post("http://d-phone/" + name, JSON.stringify(data), function(datab) {
        console.log(datab);
    });
}

function print(text) {
    sendData("print", {message: text})
}

function playSound(sound) {
    sendData("playsound", { name: sound });
}

function hide() {
    $("#menuoption1").hide();
}


QB.Phone.Animations.BottomSlideUp = function(Object, Timeout, Percentage) {
    $(Object).css({ 'display': 'block' }).animate({
        bottom: Percentage + "%",
    }, Timeout);
}

QB.Phone.Animations.BottomSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({ 'display': 'block' }).animate({
        bottom: Percentage + "%",
    }, Timeout, function() {
        $(Object).css({ 'display': 'none' });
    });
}

QB.Phone.Animations.TopSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({ 'display': 'block' }).animate({
        top: Percentage + "%",
    }, Timeout);
}

QB.Phone.Animations.TopSlideUp = function(Object, Timeout, Percentage, cb) {
    $(Object).css({ 'display': 'block' }).animate({
        top: Percentage + "%",
    }, Timeout, function() {
        $(Object).css({ 'display': 'none' });
    });
}

$(document).on('click', '.phone-application', function(e) {
    e.preventDefault();
    var PressedApplication = $(this).data('app');
    var AppObject = $("." + PressedApplication + "-app");
    CloseAll();
    if (PressedApplication == "settings") {
        sendData("LoadSettings")
    } else if (PressedApplication == "contacts") {
        $(".phone-applications").hide();
        $(".phone-app").show(500)
        $(".phone-contacts").show();
        $("#phone-homebar").show(500)
    } else if (PressedApplication == "call") {
        $(".phone-applications").hide();
        $(".phone-all-call-sector").hide();
        $(".phone-enter-sector").hide();
        $(".phone-call").show(500)
        $(".phone-call-sector").show(500)
        $(".phone-enter-sector").show(500)
        $("#phone-homebar").show(500)
    } else if (PressedApplication == "messages") {
        sendData("loadrecentmessage", {})

        // $(".phone-applications").hide();
        // $(".phone-recent-message").show(500)
    } else if (PressedApplication == "services") {
        if (servicesloaded == true) {
            $(".phone-applications").hide();
            $(".phone-services-message").hide();
            $(".phone-services-sector").show();
            $(".phone-services").show(500)
            $("#phone-homebar").show(500)
        } else {
            sendData("LoadServices")
            $("#phone-homebar").show(500)
        }
    } else if (PressedApplication == "business") {
        let job = $(this).data('job');
        $(".phone-businessapp").show();
        sendData("showBusiness", { job: job })
        $(".phone-settings").hide();
        $("#phone-homebar").show(500)
        currentjob = job
    } else if (PressedApplication == "radio") {
        $(".phone-applications").hide();
        $(".phone-radio-sector").hide(0)
        $(".phone-radio").show(500)
        $(".phone-radio-sector").show(500)
        $("#phone-homebar").show(500)
    } else if (PressedApplication == "camera") {
        sendData("openCamera");
        $(".phone-applications").show();
    } else if (PressedApplication == "twitter") {
        $(".phone-applications").hide();
        sendData("twitter:open");
        $("#phone-homebar").show(500)
        // $(".phone-twitter").fadeIn(500);
        // $(".phone-tweets").fadeIn(500);
    } else if (PressedApplication == "bank") {
        $(".phone-applications").hide();
        sendData("banking:open");
    } else if (PressedApplication == "advertisement") {
        $(".phone-applications").hide();
        $("#phone-homebar").show(500)
        sendData("advertisement:open");
        // $(".phone-advertisement").show(500)
    }  else if (PressedApplication == "dmarket") {
        $(".phone-applications").hide();
        $("#phone-homebar").show(500)
        sendData("dmarket:open");

        // $(".phone-dmarket").show(500)
    } 

});

$(document).on('click', '#changewallpaper', function() {
    $(".phone-settings-wallpaper ").show(500)
});

$(document).on('click', '#backwallaper', function() {
    $(".phone-settings-wallpaper ").fadeOut(250);
});

$(document).on('click', '#pswsubmitbutton', function() {
    var avatar = $('#psw').val();
    var message1 = $('#psw').val().toLowerCase();

    if (message1.indexOf('script') > -1 ||  message1.includes("<audio") == true || message1.includes("</audio") == true || message1.includes("html") == true || message1.includes("iframe") == true || message1.includes("src") == true || message1.includes("div") == true || message1.includes("div") == true || message1.includes("mp4") == true || message1.includes("<") == true || message1.includes(">") == true ) {
        sendData("notification", { text: 'Nice try d:^)', length: 5000 })
    } else {
        if (avatar.includes("png") == true || avatar.includes("jpeg") == true || avatar.includes("jpg") == true || avatar.includes("gif") == true) {
            sendData("changewallpaper", {
                url: avatar
            });

            $(".phone-settings-wallpaper ").fadeOut(250);
        } else {
            sendData("notification", { text: locale.avatarerror, length: 5000 })
        }
    }
});

function ChangeWallpaper(url) {
    if (url == '') {
        $('.phone-background').css('background-image', 'url(' + backgroundurl + ')');
    } else {
        $('.phone-background').css('background-image', 'url("' + url + '")');
        $('.phone-background').css('background-size', 'cover');
    }
}

function flightmode() {
    if (document.getElementById('flightmode').checked) {
        sendData("flightmode", { state: 1 });
        $("#phone-flightmode").show();
    } else {
        sendData("flightmode", { state: 0 });
        $("#phone-flightmode").hide();
    };
};

function mute() {
    if (document.getElementById('mute').checked) {
        mutes = true
        $("#phone-mute").show();
    } else {
        mutes = false
        $("#phone-mute").hide();
    };
};

function darkmodetoggle() {
    if (document.getElementById('darkmodetoggle').checked) {
        Darkmode();
        darkmode = true
        sendData("changedarkmode", { state: 1 });
    } else {
        darkmode = false
        Whitemode();
        sendData("changedarkmode", { state: 0 });
    };
};


/*  Notification  */
function CreateNotification(data) {
    let $notification = $(document.createElement('div'));
    $notification.addClass('notify');
    $notification.html(data.text);
    $notification.css({ "border-left": "1vh solid " + data.color });
    $notification.fadeIn();

    return $notification;
}


function ShowNotif(data) {
    let $notification = CreateNotification(data);
    $('.notification').append($notification);
    setTimeout(function() {
        $.when($notification.fadeOut()).done(function() {
            $notification.remove()
        });
    }, data.length != null ? data.length : 2500);
}

let selectedservice = 'null'
let serviceopen = 'null'

$(document).on('click', '#phone-service-return', function() {
    if (serviceopen == 'null') {
        $(".phone-services").hide();
        $(".phone-applications").show(500)
    } else if (serviceopen == 'sendmessage') {
        $(".phone-services-message").hide();
        $(".phone-services-sector").show(500)

        serviceopen = 'null'
    }
});

$(document).on('click', '.phone-service', function() {
    $(".phone-services-sector").hide();
    $(".phone-services-message").show(500)

    serviceopen = 'sendmessage'
    selectedservice = $(this).data('service');
});

$(document).on('click', '#phone-service-button', function() {
    $(".phone-services-sector").show();
    $(".phone-services-message").hide();
    $(".phone-services").hide();
    $(".phone-applications").show(500)
    serviceopen = 'null'

    let sendnumber = 0
    let sendgps = 0
    selectednumber = selectedservice
    let message = $(".phone-service-message-input").val()
    if (document.getElementById('sendnumber').checked) {
        sendnumber = 1
    }
    if (document.getElementById('sendgps').checked) {
        sendgps = 1
    }
    let message1 = $('.phone-service-message-input').val().toLowerCase();
    if (message1.indexOf('script') > -1 || message1.indexOf('http') > -1 || message1.indexOf('www') > -1 || message1.includes("<audio") == true || message1.includes("</audio") == true) {
        sendData("notification", { text: 'Nice try d:^)', length: 5000 })
    } else {
        if (message.length > 0) {
            sendData("sendservice", { service: selectedservice, message: message, sendnumber: sendnumber, job: currentjob, sendgps: sendgps })
        } else {
            sendData("notification", { text: locale.notempty, length: 5000 })
        }
    };

});

let businessapp = null

function loadBusiness(item) {
    businessapp = item
    if (businessicon == true) {
        document.getElementById("businessicon").remove();
    }

    $('.phone-home-applications').append(item);
    businessicon = true
    $("#businessicon").css("background", "linear-gradient(to bottom, #8c47fc 0%, #6612c7 100%)")
}

function showBusiness(member, onlinemember, motd) {
    $(".phone-ba-member-list").children().detach();
    $(".phone-ba-member-list").append(member);

    document.getElementById('phone-ba-member').innerHTML = locale.memberonline + ' : ' + onlinemember;
    document.getElementById('phone-ba-motd-inhalt').innerHTML = motd;

    $(".phone-recent-businessapp-sector").hide();
    $(".phone-businessapp-message").hide();
    $(".phone-applications").hide();
    $(".phone-businessapp-settings").hide();
    CloseAll();
    $(".phone-businessapp-sector").show();
    $(".phone-businessapp").show(500)
    $("#phone-homebar").show(500)
}

$(document).on('click', '#phone-businessapp-return', function() {
    $(".phone-applications").hide();
    $(".phone-businessapp").show(500)
});

$(document).on('click', '#phone-ba-member-call', function() {
    let name = $(this).data('name');
    let number = $(this).data('number');

    var element = document.getElementById("phone-call-outgoing-caller");
    element.innerHTML = name
    $(".phone-call").hide();
    $(".phone-businessapp").hide();
    $(".phone-call-app").show();
    $(".phone-call-outgoing").show(500)

    if (mutes == true) {
        sendData("notification", { text: locale.yourecallingsb, length: 5000 })
    } else {
        if (outgoingsound != null) {
            outgoingsound.pause();
        }

        outgoingsound = new Audio("./sound/Phonecall.ogg");
        outgoingsound.volume = 0.2;
        outgoingsound.loop = true;
        outgoingsound.currentTime = 0;
        outgoingsound.play();
    }


    sendData("startcall", { number: number, contact: name });

    lastcontact = 'null'
});

$(document).on('click', '#phone-ba-member-message', function() {
    let number = $('#phone-ba-member-call').data('number');
    let name = $('#phone-ba-member-call').data('name');
    $(".phone-businessapp").hide();

    selectednumber = number

    sendData("loadmessage", {
        number: number
    });
});

$(document).on('click', '#pbf-member', function() {
    $(".phone-businessapp-settings").hide();
    $(".phone-businessapp-rank-sector").hide();
    $(".phone-businessapp-newrank-sector").hide();
    $(".phone-businessapp-money-sector").hide(0);
    sendData("showBusiness", { job: currentjob })
});

$(document).on('click', '#pbf-messages', function() {
    $(".phone-businessapp-settings").hide();
    $(".phone-businessapp-rank-sector").hide();
    $(".phone-businessapp-newrank-sector").hide();
    $(".phone-businessapp-money-sector").hide(0);
    sendData("showBusinessMessages", { job: currentjob })
});

$(document).on('click', '#pbf-settings', function() {
    $(".phone-recent-businessapp-sector").hide();
    $(".phone-businessapp-message").hide();
    $(".phone-businessapp-rank-sector").hide();
    $(".phone-businessapp-newrank-sector").hide();
    $(".phone-businessapp-money-sector").hide(0);
    $(".phone-businessapp-sector").hide();
    $(".phone-businessapp-settings").show(500)
});

function loadrecentbusinessmessages(html) {
    $(".phone-recent-businessapp-sector").children().detach();
    $(".phone-recent-businessapp-sector").append(html);
    if (darkmode == true) {
        Darkmode();
    }

    $(".phone-businessapp-sector").hide();
    $(".phone-recent-businessapp-sector").show(500)
}

$(document).on('click', '.phone-recent-businessapp-selection', function() {
    let number = $(this).data('number');
    selectednumber = $(this).data('number');
    lastservicenumber = selectednumber
    sendData("loadbusinessmessage", {
        number: number,
        job: currentjob
    });


});

function loadbusinessmessages(html, div) {
    $(".phone-businessapp-message").children().detach();
    $(".phone-businessapp-message").append(div);
    $("#pbbacceptfont ").html(locale.pbbacceptfont);
    $("#pbbacceptfont2 ").html(locale.pbbacceptfont2);
    $(".phone-businessapp-chat").children().detach();
    $(".phone-businessapp-chat").append(html);
    if (darkmode == true) {
        Darkmode();
    }
    $(".phone-recent-businessapp-sector").hide();
    $(".phone-businessapp-message").show(500)
    $(".phone-businessapp-chat").scrollTop($(".phone-businessapp-chat")[0].scrollHeight);
    lastwindow = "businessmessage"
}

function reloadbusinessmessages(html, div) {
    $(".phone-businessapp-message").children().detach();
    $(".phone-businessapp-message").append(div);
    $("#pbbacceptfont ").html(locale.pbbacceptfont);
    $("#pbbacceptfont2 ").html(locale.pbbacceptfont2);
    $(".phone-businessapp-chat").children().detach();
    $(".phone-businessapp-chat").append(html);
    if (darkmode == true) {
        Darkmode();
    }
    $(".phone-businessapp-chat").scrollTop($(".phone-businessapp-chat")[0].scrollHeight);
    lastwindow = "businessmessage"
}

$(document).on('click', '#phone-businessapp-send', function() {
    var message = $('#phone-business-input-message').val();
    let message1 = $('#phone-business-input-message').val().toLowerCase();

    if (message1.indexOf('script') > -1 || message1.indexOf('http') > -1 || message1.indexOf('www') > -1 || message1.includes("<audio") == true || message1.includes("</audio") == true) {
        sendData("notification", { text: 'Nice try d:^)', length: 5000 })
    } else {
        if (message.length > 0) {
            sendData("sendbusinessmessage", {
                message: message,
                number: selectednumber,
                job: currentjob
            });
        } else {
            sendData("notification", { text: locale.notempty, length: 5000 })
        }
    };


    document.getElementById('phone-business-input-message').value = "";
});

$(document).on('click', '#phone-businessapp-placeicon', function() {
    sendData("sendbusinessgps", {
        number: selectednumber,
        job: currentjob
    });
});

$(document).on('click', '#phone-businessapp-return', function() {
    $(".phone-recent-businessapp-sector").hide();
    $(".phone-businessapp-message").hide();
    $(".phone-businessapp-settings").hide();
    $(".phone-businessapp-sector").show();
    $(".phone-businessapp").hide();

    $(".phone-applications").show(500)

    lastwindow = null
});

$(document).on('click', '#enablejobnumber', function() {
    sendData("enablejobnumber", { job: currentjob })
});

$(document).on('click', '#changemotd', function() {
    $(".phone-businessapp-motd").show(500)
});

$(document).on('click', '#backmotd', function() {
    $(".phone-businessapp-motd").fadeOut(250);
});

let businessid = null
$(document).on('click', '#phone-ba-member-managment', function() {
    $(".phone-businessapp-sector").hide(0);
    $(".phone-businessapp-rank-sector").show(500)
    var name = $(this).data('name');
    var rank = $(this).data('rank');
    var grade = $(this).data('grade');
    businessid = $(this).data('id');
    $("#pbrs-name").html(name);
    $("#pbrs-rankname").html(rank);
    $("#pbrs-grade").html(grade);
});

$(document).on('click', '#pbrs-uprank', function() {
    sendData("businessapp:uprank", { id: businessid, grade: $("#pbrs-grade").html() })
    CloseAll();
    Home();

});
$(document).on('click', '#pbrs-derank', function() {
    sendData("businessapp:derank", { id: businessid, grade: $("#pbrs-grade").html() })
    CloseAll();
    Home();

});

$(document).on('click', '#pbrs-fire', function() {
    sendData("businessapp:fire", { id: businessid })
    CloseAll();
    Home();

});

$(document).on('click', '#pbrs-recruit', function() {
    let id = $("#pbns-id").val();
    let newrank = $("#pbns-newrank2").val();

    let message1 = $('#pbns-id').val().toLowerCase();
    let newrank2 = $('#pbns-newrank2').val().toLowerCase();
    
    if (message1.indexOf('script') > -1 || message1.indexOf('http') > -1 || message1.indexOf('www') > -1 || message1.includes("<audio") == true || message1.includes("</audio") == true) {
        sendData("notification", { text: 'Nice try d:^)', length: 5000 })
    } else {
        if (newrank2.indexOf('script') > -1 || newrank2.indexOf('http') > -1 || newrank2.indexOf('www') > -1 || newrank2.includes("<audio") == true || newrank2.includes("</audio") == true) {
            sendData("notification", { text: 'Nice try d:^)', length: 5000 })
        } else {
            sendData("businessapp:recruit", { id: id, rank: newrank })
        };
    };
    

    CloseAll();
    Home();

});

$(document).on('click', '#pbrs-updaterank', function() {
    let newrank = $("#pbns-newrank").val();
    let message1 = $('#pbns-newrank').val().toLowerCase();

    if (message1.indexOf('script') > -1 || message1.indexOf('http') > -1 || message1.indexOf('www') > -1 || message1.includes("<audio") == true || message1.includes("</audio") == true) {
        sendData("notification", { text: 'Nice try d:^)', length: 5000 })
    } else {
        sendData("businessapp:updaterank", { id: businessid, rank: newrank })
    };


    CloseAll();
    Home();
});

$(document).on('click', '#seejobmoney', function() {
    $(".phone-businessapp-settings").hide(0);
    $(".phone-businessapp-money-sector").show(500)
    $("#pbms-money").html(businessmoney + "$");
});

$(document).on('click', '#pmbs-deposit', function() {
    let amount = $("#pbms-amount").val();
    let message1 = $('#pbms-amount').val().toLowerCase();
    if (message1.indexOf('script') > -1 || message1.indexOf('http') > -1 || message1.indexOf('www') > -1 || message1.includes("<audio") == true || message1.includes("</audio") == true) {
        sendData("notification", { text: 'Nice try d:^)', length: 5000 })
    } else {
        sendData("businessapp:depositmoney", { amount: amount })
    };
});

$(document).on('click', '#pmbs-withdraw', function() {
    let amount = $("#pbms-amount").val();
    let message1 = $('#pbms-amount').val().toLowerCase();
    if (message1.indexOf('script') > -1 || message1.indexOf('http') > -1 || message1.indexOf('www') > -1 || message1.includes("<audio") == true || message1.includes("</audio") == true) {
        sendData("notification", { text: 'Nice try d:^)', length: 5000 })
    } else {
        sendData("businessapp:withdrawmoney", { amount: amount })
    };
    
});


$(document).on('click', '#phone-addnewmember', function() {
    $(".phone-businessapp-sector").hide(0);
    $(".phone-businessapp-newrank-sector").show(500)
});

$(document).on('click', '#motdsubmit', function() {
    $(".phone-businessapp-motd").fadeOut(250);
    var message = $('#motd').val();
    let message1 = $('#motd').val().toLowerCase();
    if (message1.indexOf('script') > -1 || message1.indexOf('http') > -1 || message1.indexOf('www') > -1 || message1.includes("<audio") == true || message1.includes("</audio") == true) {
        sendData("notification", { text: 'Nice try d:^)', length: 5000 })
    } else {
        sendData("changemotd", { job: currentjob, message: message })
    };
   
});

function bpbaccept() {
    var acceptbutton = "#bpb-accept-" + selectednumber
    var declinebutton = "#bpb-decline-" + selectednumber

    $(acceptbutton).css({ 'width': '0%', "tranistion": ".5" });
    $(acceptbutton).css({ 'display': 'none' });
    $(declinebutton).css({ 'width': '100%', "tranistion": ".5" });


    sendData("serviceaccept", {
        number: selectednumber,
        job: currentjob
    })
}

function bpbdecline() {
    var acceptbutton = "#bpb-accept-" + selectednumber
    var declinebutton = "#bpb-decline-" + selectednumber


    sendData("serviceclose", {
        number: selectednumber,
        job: currentjob
    })

    $(acceptbutton).css({ 'display': 'none' });
    $(declinebutton).css({ 'width': '50%', "tranistion": ".5" });

    syncclosebmessage(selectednumber)
}

function syncclosebmessage(number) {
    if (lastservicenumber == number) {
        $(".phone-businessapp-message").hide();
        sendData("showBusinessMessages", { job: currentjob })

        lastservicenumber = null
    }
}

function syncbpbabutton(selectednumber) {
    var acceptbutton = "#bpb-accept-" + selectednumber
    var declinebutton = "#bpb-decline-" + selectednumber

    $("#pbbacceptfont ").html(locale.pbbacceptfont);
    $("#pbbacceptfont2 ").html(locale.pbbacceptfont2);
    $(acceptbutton).css({ 'display': 'none', "tranistion": ".5" });
    $(declinebutton).css({ 'width': '100%', "tranistion": ".5" });

}


function LoadServices(services) {
    $(".phone-services-list").children().detach();
    $(".phone-services-list").append(services);
    if (darkmode == true) {
        Darkmode();
    }
    CloseAll()
    $(".phone-services").show(500)

    servicesloaded = true
}


/* Sound */
function PlayMessageSound() {
    if (mutes == false) {
        if (messagesound != null) {
            messagesound.pause();
        }

        messagesound = new Audio("./sound/Google_Event.ogg");
        messagesound.volume = 0.2;
        messagesound.currentTime = 0;
        messagesound.play();

        setTimeout(function() {;
            messagesound.pause();
            messagesound.currentTime = 0;
            messagesound.volume = 0.2;
        }, 1300);
    }
}

function PlayBMessageSound() {
    if (mutes == false) {
        if (bmessagesound != null) {
            bmessagesound.pause();
        }

        bmessagesound = new Audio("./sound/message_tone.ogg");
        bmessagesound.volume = 0.2;

        bmessagesound.currentTime = 0;
        bmessagesound.play();

        setTimeout(function() {;
            bmessagesound.pause();
            bmessagesound.currentTime = 0;
            bmessagesound.volume = 0.2;
        }, 1300);
    }
}

/* Radio */
$(document).on('click', '#phone-radio-return', function() {
    $(".phone-radio").hide();
    $(".phone-applications").show(500)
});

$(document).on('click', '#phone-frequenz-join-button', function() {
    var freq = $('#phone-radio-frequenz-input').val();
    var message1 = $('#phone-radio-frequenz-input').val().toLowerCase();

    if (message1.indexOf('script') > -1 || message1.indexOf('http') > -1 || message1.indexOf('www') > -1 || message1.includes("<audio") == true || message1.includes("</audio") == true) {
        sendData("notification", { text: 'Nice try d:^)', length: 5000 })
    } else {
        sendData("setRadio", { freq: freq })
    }
});

$(document).on('click', '#phone-frequenz-leave-button', function() {
    var freq = $('#phone-radio-frequenz-input').val();
    var message1 = $('#phone-radio-frequenz-input').val().toLowerCase();

    if (message1.indexOf('script') > -1 || message1.indexOf('http') > -1 || message1.indexOf('www') > -1 || message1.includes("<audio") == true || message1.includes("</audio") == true) {
        sendData("notification", { text: 'Nice try d:^)', length: 5000 })
    } else {
        sendData("leaveRadio", { freq: freq })
    }
});

let constantradio = false
$(document).on('click', '#phone-constant-radio', function() {
    if (constantradio == false) {
        constantradio = true
        $("#phone-constant-radio").addClass("disphone-constant-radio")
        $("#phone-constant-radio").html(locale.disableconstant);
        sendData("constantradio", { state: constantradio })
    } else {
        constantradio = false
        $("#phone-constant-radio").removeClass("disphone-constant-radio")
        $("#phone-constant-radio").html(locale.enableconstant);
        sendData("constantradio", { state: constantradio })
    }
});
/* Update Time */
function UpdateTime(data) {
    var NewDate = new Date();
    var NewHour = NewDate.getHours();
    var NewMinute = NewDate.getMinutes();
    var Minutessss = NewMinute;
    var Hourssssss = NewHour;
    if (NewHour < 10) {
        Hourssssss = "0" + Hourssssss;
    }
    if (NewMinute < 10) {
        Minutessss = "0" + NewMinute;
    }
    var MessageTime = Hourssssss + ":" + Minutessss

    $("#phone-time").html(MessageTime);
}

function CloseAll() {
    $(".phone-call").hide();
    $(".phone-call-app").hide();
    $(".phone-call-ongoing").hide();
    $(".phone-call-incoming").hide();
    $(".phone-call-outgoing").hide();
    $(".phone-applications").hide();
    $(".phone-app").hide();
    $(".phone-contacts").hide();
    $(".phone-contacts-information").hide();
    $(".phone-contacts-add").hide();
    $(".phone-contacts-edit").hide();
    $(".phone-recent-message").hide();
    $(".phone-message").hide();
    $(".phone-settings").hide();
    $(".phone-services").hide();
    $(".phone-businessapp").hide();
    $(".phone-businessapp-rank-sector").hide();
    $(".phone-businessapp-newrank-sector").hide();
    $(".phone-businessapp-money-sector").hide(0);
    $(".phone-radio").hide();
    $(".phone-twitter").hide();
    $(".phone-bankapp").hide();
    $(".phone-applications").hide();
    $(".phone-bankapp-transfer").fadeOut(0);
    $(".phone-bankapp-home").fadeOut(0);
    $("#pcb-transfer").removeClass("activeposition");
    $("#pcb-home").removeClass("activeposition");

    $(".phone-advertisement").fadeOut(0);
    $(".phone-dmarket").fadeOut(0);
}

function Home() {
    CloseAll();
    $(".phone-applications").show(500)
}


function Darkmode() {


    $(".phone-footer-applications").addClass('darkphone-footer-applications');
    $(".phone-header").addClass('darkphone-header');
    $(".phone-homebar").addClass('darkphone-homebar');

    /* Phone App */
    $(".phone-enter").each(function() {
        $(this).addClass('darkphone-enter');
    });
    $(".phone-enterinvisibleicon").addClass('darkphone-enterinvisibleicon');
    $(".phone-call-footer-item").addClass('darkphone-call-footer-item');
    $(".phone-returnicon").each(function() {
        $(this).addClass('darkphone-returnicon')
    });

    /* Call App */
    $(".phone-call-app").addClass('darkmode');
    $(".phone-call").addClass('darkmode');
    $(".bigincallsymbol").addClass('darkbigincallsymbol');

    /* Contacts App */
    $(".phone-app").addClass('darkmode');
    $(".phone-app-header").each(function() {
        $(this).addClass('darkmodeheader')
    });
    $(".phone-contact").addClass('darkphone-contact');
    $("#pcinumber").addClass('darkpcinumber');
    $(".pciinput").addClass('darkpciinput');

    /* Radio App */
    $(".phone-radio").addClass('darkmode');
    $(".phone-radio-frequenz-input").addClass('darkpciinput');

    /* Settings App */
    $(".phone-settings").addClass('darkmode');
    $(".phone-settings-header").addClass('darkmodeheader')
    $(".phone-settings-selection").addClass('darkphone-settings-selection');
    $("#customwallpaper").addClass('whitecolor');

    /* Recent Messages App */
    $(".phone-recent-message").addClass('darkmode');
    $(".phone-message-header").addClass('darkmodeheader');

    $(".phone-recent-messages-selection").each(function() {
        $(this).addClass('darkphone-recent-message-settings')
        if ($(this).hasClass('me')) {
            $(this).removeClass('me')
            $(this).addClass('darkme')
        }
    });

    $(".phone-recent-message-settings").addClass('darkphone-recent-message-settings');
    $(".prmsheadline").addClass('darkprmsheadline');
    $("#phonerecentmessagesearchbar").addClass('darkprmsheadline');

    $("#prm-message").each(function() {
        $(this).addClass('darkprm-message')
    });
    
    $("newmessage").each(function() {
        $(this).addClass('darknewmessage')
    });

    /*  Messages App */
    $(".phone-message").addClass('darkmode');
    $(".phone-message-header").addClass('darkmodeheader');

    $(".phone-chat-message").each(function() {
        $(this).addClass('darkphone-chat-message')
        if ($(this).hasClass('me')) {
            $(this).removeClass('me')
            $(this).addClass('darkme')
        }
    });

    $(".phone-chat-message-header").each(function() {
        $(this).addClass('darkphone-chat-message-header')
    });

    $(".sendservicenumber").each(function() {
        $(this).addClass('darksendservicenumber')
    });

    $("#phone-chat-input-message").addClass('darkpciinput');
    $("#phone-chat-placeicon").addClass('darkphone-chat-placeicon');

    /*  Service App */
    $(".phone-services").addClass('darkmode');
    $(".phone-app-header").addClass('darkmodeheader');

    $(".phone-service-selection").each(function() {
        $(this).addClass('darkphone-service-selection')
    });

    $(".phone-service").each(function() {
        $(this).addClass('darkphone-service-selection')
    });
    $(".phone-service-message-input ").addClass('darkpciinput');

    /*  Business App */
    $(".phone-businessapp").addClass('darkmode');
    $(".phone-app-header").each(function() {
        $(this).addClass('darkmodeheader')
    });

    $(".phone-recent-businessapp-selection").each(function() {
        $(this).addClass('darkmode-prms')
    });

    $(".phone-businessapp-inputt").addClass('darkpciinput');
    $("#phone-businessapp-placeicon").addClass('darkphone-chat-placeicon');

    $(".phone-businessapp-settings-menu").each(function() {
        $(this).addClass('darkphone-businessapp-settings-menu')
    });
    $(".phone-businessapp-footer-item").each(function() {
        $(this).addClass('darkphone-businessapp-footer-item')
    });

    $(".phone-businessapp-motd").addClass('darkminiinput');
    $(".phone-settings-wallpaper").addClass('darkminiinput');

    /*  Twitter App */
    $(".phone-twitter").addClass('darkmode');
    $(".phone-twitter-header").addClass('darkheader');
    $(".phone-tweet ").each(function() {
        $(this).addClass('darkphone-tweet')
    });
    $(".phone-tweet-header").each(function() {
        $(this).addClass('darkphone-tweet-header')
    });
    $(".phone-tweet-name").each(function() {
        $(this).addClass('darkphone-tweet-name')
    });
    $(".phone-tweet-footer").each(function() {
        $(this).addClass('darkphone-tweet-footer')
    });
    $(".phone-tweet-input").each(function() {
        $(this).addClass('darkphone-tweet-input')
    });
    $(".ptw-submitzone").each(function() {
        $(this).addClass('darkptw-submitzone')
    });

    // Bankapp
    $(".phone-bankapp").addClass('darkphone-bankapp');
    $(".phone-bankapp-home").addClass('darkphone-bankapp-home');
    $(".phone-bankapp-transfer").addClass('darkphone-bankapp-home');
    $(".bankapp-account-header").addClass('darkbankapp-account-header');

    $(".bankapp-account-class").each(function() {
        $(this).addClass('darkbankapp-account-class')
    });

    $(".phone-bankapp-transaction-bottom").each(function() {
        $(this).addClass('darkphone-bankapp-transaction-bottom')
    });

    $(".phone-bankapp-footer").addClass('darkphone-bankapp-footer');

    // advertisement
    $(".phone-advertisement").addClass('darkmode');
    $(".life-message").each(function() {
        $(this).addClass('darklife-message')
    });
    $(".advertisement-textarea").each(function() {
        $(this).addClass('darkadvertisement-textarea')
    });

    // DMARKET
    $(".phone-dmarket").addClass('darkmode');
    $(".dmarket-item-product").each(function() {
        $(this).addClass('darkdmarket-item-product')
    });
    $(".dmarket-product").each(function() {
        $(this).addClass('darkdmarket-product')
    });

    // general
    $(".phone-input").each(function() {
        $(this).addClass('darkphone-input')
    });
}

function Whitemode() {
    $(".phone-footer-applications").removeClass('darkphone-footer-applications');
    $(".phone-header").removeClass('darkphone-header');
    $(".phone-homebar").removeClass('darkphone-homebar');

    /* Phone App */
    $(".phone-enter").each(function() {
        $(this).removeClass('darkphone-enter');
    });
    $(".phone-enterinvisibleicon").removeClass('darkphone-enterinvisibleicon');
    $(".phone-call-footer-item").removeClass('darkphone-call-footer-item');
    $(".phone-returnicon").each(function() {
        $(this).removeClass('darkphone-returnicon')
    });

    /* Call App */
    $(".phone-call-app").removeClass('darkmode');
    $(".phone-call").removeClass('darkmode');
    $(".bigincallsymbol").removeClass('darkbigincallsymbol');

    /* Contacts App */
    $(".phone-app").removeClass('darkmode');
    $(".phone-app-header").each(function() {
        $(this).removeClass('darkmodeheader')
    });
    $("#pcinumber").removeClass('darkpcinumber');
    $(".pciinput").removeClass('darkpciinput');
    $(".phone-contact").each(function() {
        $(this).removeClass('darkphone-contact')
    });

    /* Radio App */
    $(".phone-radio").removeClass('darkmode');
    $(".phone-radio-frequenz-input").removeClass('darkpciinput');

    /* Settings App */
    $(".phone-settings").removeClass('darkmode');
    $(".phone-settings-header").removeClass('darkmodeheader')
    $(".phone-settings-selection").removeClass('darkphone-settings-selection');
    $("#customwallpaper").removeClass('whitecolor');

    /* Recent Messages App */
    $(".phone-recent-message").removeClass('darkmode');
    $(".phone-message-header").removeClass('darkmodeheader');

    $(".phone-recent-messages-selection").each(function() {
        $(this).removeClass('darkphone-recent-message-settings')
        if ($(this).hasClass('me')) {
            $(this).addClass('me')
            $(this).removeClass('darkme')
        }
    });

    $(".phone-recent-message-settings").removeClass('darkphone-recent-message-settings');
    $(".prmsheadline").removeClass('darkprmsheadline');
    $("#phonerecentmessagesearchbar").removeClass('darkprmsheadline');

    $("#prm-message").each(function() {
        $(this).removeClass('darkprm-message')
    });
    
    $("newmessage").each(function() {
        $(this).removeClass('darknewmessage')
    });

    /*  Messages App */
    $(".phone-message").removeClass('darkmode');
    $(".phone-message-header").removeClass('darkmodeheader');

    $(".phone-chat-message").each(function() {
        $(this).removeClass('darkphone-chat-message')
        if ($(this).hasClass('me')) {
            $(this).addClass('me')
            $(this).removeClass('darkme')
        }
    });

    $(".phone-chat-message-header").each(function() {
        $(this).removeClass('darkphone-chat-message-header')
    });

    $(".sendservicenumber").each(function() {
        $(this).removeClass('darksendservicenumber')
    });

    $("#phone-chat-input-message").removeClass('darkpciinput');
    $("#phone-chat-placeicon").removeClass('darkphone-chat-placeicon');
    /*  Service App */
    $(".phone-services").removeClass('darkmode');
    $(".phone-app-header").removeClass('darkmodeheader');

    $(".phone-service-selection").each(function() {
        $(this).removeClass('darkphone-service-selection')
    });

    $(".phone-service").each(function() {
        $(this).removeClass('darkphone-service-selection')
    });
    $(".phone-service-message-input ").removeClass('darkpciinput');

    /*  Business App */
    $(".phone-businessapp").removeClass('darkmode');
    $(".phone-app-header").each(function() {
        $(this).removeClass('darkmodeheader')
    });

    $(".phone-recent-businessapp-selection").each(function() {
        $(this).removeClass('darkmode-prms')
    });

    $(".phone-businessapp-inputt").removeClass('darkpciinput');
    $("#phone-businessapp-placeicon").removeClass('darkphone-chat-placeicon');

    $(".phone-businessapp-settings-menu").each(function() {
        $(this).removeClass('darkphone-businessapp-settings-menu')
    });
    $(".phone-businessapp-footer-item").each(function() {
        $(this).removeClass('darkphone-businessapp-footer-item')
    });

    $(".phone-businessapp-motd").removeClass('darkminiinput');
    $(".phone-settings-wallpaper").removeClass('darkminiinput');
    /*  Twitter App */
    $(".phone-twitter").removeClass('darkmode');
    $(".phone-twitter-header").removeClass('darkheader');
    $(".phone-tweet ").each(function() {
        $(this).removeClass('darkphone-tweet')
    });
    $(".phone-tweet-header").each(function() {
        $(this).removeClass('darkphone-tweet-header')
    });
    $(".phone-tweet-name").each(function() {
        $(this).removeClass('darkphone-tweet-name')
    });
    $(".phone-tweet-footer").each(function() {
        $(this).removeClass('darkphone-tweet-footer')
    });
    $(".phone-tweet-input").each(function() {
        $(this).removeClass('darkphone-tweet-input')
    });
    $(".ptw-submitzone").each(function() {
        $(this).removeClass('darkptw-submitzone')
    });

    // Bankapp
    $(".phone-bankapp").removeClass('darkphone-bankapp');
    $(".phone-bankapp-home").removeClass('darkphone-bankapp-home');
    $(".phone-bankapp-transfer").removeClass('darkphone-bankapp-home');
    $(".bankapp-account-header").removeClass('darkbankapp-account-header');
    $(".bankapp-account-class").each(function() {
        $(this).removeClass('darkbankapp-account-class')
    });

    $(".phone-bankapp-transaction-bottom").each(function() {
        $(this).removeClass('darkphone-bankapp-transaction-bottom')
    });
    $(".phone-bankapp-footer").removeClass('darkphone-bankapp-footer');

    // advertisement
    $(".phone-advertisement").removeClass('darkmode');
    $(".life-message").each(function() {
        $(this).removeClass('darklife-message')
    });
    $(".advertisement-textarea").each(function() {
        $(this).removeClass('darkadvertisement-textarea')
    });

    // DMARKET
    $(".phone-dmarket").removeClass('darkmode');
    $(".dmarket-item-product").each(function() {
        $(this).removeClass('darkdmarket-item-product')
    });
    $(".dmarket-product").each(function() {
        $(this).removeClass('darkdmarket-product')
    });

    // general
    $(".phone-input").each(function() {
        $(this).removeClass('darkphone-input')
    });
}

$(document).on('click', '#phone-homebar', function() {

    if (lastwindow == "wallpaper") {
        $(".phone-settings-sector").show(500)
        $(".phone-settings-inner").hide(500)
        $("#headerback").hide(500)
        lastwindow = null
    } 
    CloseAll();
    if (lasthomebarwindow == "chat") {
        sendData("loadrecentmessage", {})
        $("#phone-homebar").fadeIn(250);
        lasthomebarwindow = null
        lastwindow = null
    } else {
        sendData("activeappnone", {})
        $(".phone-applications").fadeIn(250);
        $("#phone-homebar").fadeOut(0);
    }

    if (callstatus == "ongoing") {
        $(".bigincallsymbol").fadeIn(500)
        $(".callheadername").html(callnumber)
    } else if (callstatus == "incall") {
        $(".bigincallsymbol").fadeIn(500)
        $(".callheadername").html(callnumber)
    }

    sendData("SetNuiFocusKeepInputFalse");
});

$(document).on('click', '#headerback', function() {
    if (lastwindow == "wallpaper") {
        $(".phone-settings-sector").show(500)
        $(".phone-settings-inner").hide(500)
        $("#headerback").hide(500)
        $(".phone-homebar").show(500)
        lastwindow = "settings"
    } else {
        // sendData("activeappnone", {})
        // $(".phone-applications").fadeIn(250);
        // $("#phone-homebar").fadeOut(0);
    }

    sendData("SetNuiFocusKeepInputFalse");
});
