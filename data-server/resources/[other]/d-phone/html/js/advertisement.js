$(function() {

    window.addEventListener("message", function(event) {
        var v = event.data;

        if (v.loadad == true) {
            LoadAdvertisements(v.html)
            $("#phone-homebar").fadeIn(250);
        } else if (v.refreshad == true) {
            RefreshAdvertisements(v.html)
        }
    });
});

function LoadAdvertisements(html) {
    $(".phone-advertisement-sector").children().detach();
    $(".phone-advertisement-sector").append(html);
    

    $(".phone-advertisement").show(500)
    $(".phone-advertisement-sector").show(500)
    $("#advertisement-newmessage").show(500)
    
    if (darkmode == true) {
        Darkmode();
    }
}

function RefreshAdvertisements(html) {
    $(".phone-advertisement-sector").children().detach();
    $(".phone-advertisement-sector").append(html);
    
    if (darkmode == true) {
        Darkmode();
    }
}

$(document).on('click', '#advertisement-newmessage', function() {
    $(".phone-advertisement-sector").hide(0)
    $("#advertisement-newmessage").hide(0)
    $(".advertisement-message").show(500)
    $("#advertisement-messageval").val("")
    $("#advertisement-nameval").val("")
});

$(document).on('click', '#advertisement-back', function() {
    $(".advertisement-message").hide(0)
    $(".phone-advertisement-sector").show(500)
    $("#advertisement-newmessage").show(500)
});


$(document).on('click', '#advertisement-sendnewmessage', function() {
    let name = $("#advertisement-nameval").val()
    let message = $("#advertisement-messageval").val()
    let message1 = $('#advertisement-messageval').val().toLowerCase();

    if (message1.indexOf('script') > -1 || message1.indexOf('http') > -1 || message1.indexOf('www') > -1 || message1.includes("<audio") == true || message1.includes("</audio") == true) {
        sendData("notification", { text: 'Nice try d:^)', length: 5000 })
    } else {
        if (message.length > 0) {
            sendData("advertisement:newmessage",{name: name, message: message})
        } else {
            if (locale == "de") {
                sendData("notification", { text: localede.notempty, length: 5000 })
            } else {
                sendData("notification", { text: locale.notempty, length: 5000 })
            }
            
        }
    }

    $(".advertisement-message").hide(0)
    $(".phone-advertisement-sector").show(500)
    $("#advertisement-newmessage").show(500)

    $("#advertisement-messageval").val("")
    $("#advertisement-nameval").val("")
});

$(document).on('click', '#life-m-call', function() {
    var number = $(this).data("number")
    var element = document.getElementById("phone-call-outgoing-caller");
    element.innerHTML = number

    $(".phone-advertisement").hide(0)
    $(".phone-advertisement-sector").hide(0)
    $("#advertisement-newmessage").hide(0)
    
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

        outgoingsound = new Audio("./sound/Phonecall.ogg");
        outgoingsound.volume = soundvolume;
        outgoingsound.currentTime = 0;
        outgoingsound.loop = true;
        outgoingsound.play();
    }


    sendData("startcall", { number: number, contact: number });
});

$(document).on('click', '#life-m-message', function() {
    var number = $(this).data("number");

    sendData("loadmessage", {
        number: number
    });
    selectednumber = number;

    $(".phone-advertisement").hide(0)
    $(".phone-advertisement-sector").hide(0)
    $("#advertisement-newmessage").hide(0)
});

$(document).on('click', '#life-m-delete', function() {
    var id = $(this).data("id");

    sendData("advertisement:delete", {
        id: id
    });

    $(".life-message").each(function() {
        if ($(this).data("id") == id) {
            $(this).hide(500)
        }
    })
});