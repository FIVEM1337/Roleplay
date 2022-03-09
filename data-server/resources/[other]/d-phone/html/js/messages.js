/*  MESSAGE  */
let lastwindow = null
let privatmessage = null
lasthomebarwindow = null  


document.onkeyup = function(data) {
    if (data.which == 13) {
        if (lastwindow == "privatmessage") {
            var message = $('#phone-chat-input-message').val();
            let message1 = $('#phone-chat-input-message').val().toLowerCase();
            if (message1.indexOf('script') > -1 ||  message1.includes("<audio") == true || message1.includes("</audio") == true || message1.includes("html") == true || message1.includes("iframe") == true || message1.includes("src") == true || message1.includes("div") == true || message1.includes("div") == true || message1.includes("mp4") == true || message1.includes("<") == true || message1.includes(">") == true ) {
                sendData("notification", { text: 'Nice try d:^)', length: 5000 })
            } else {
                if (message.length > 0) {
                    sendData("sendmessage", {
                        message: message,
                        number: selectednumber
                    });
                } else {
                    if (locale == "de") {
                        $("#phone-constant-radio").html(localede.notempty);
                    } else {
                        $("#phone-constant-radio").html(locale.notempty);
                    }
                }
            };

            document.getElementById('phone-chat-input-message').value = "";
        } else if (lastwindow == "businessmessage") {
            var message = $('#phone-business-input-message').val();
            let message1 = $('#phone-business-input-message').val().toLowerCase();
            if (message1.indexOf('script') > -1 ||  message1.includes("<audio") == true || message1.includes("</audio") == true || message1.includes("html") == true || message1.includes("iframe") == true || message1.includes("src") == true || message1.includes("div") == true || message1.includes("div") == true || message1.includes("mp4") == true || message1.includes("<") == true || message1.includes(">") == true ) {
                sendData("notification", { text: 'Nice try d:^)', length: 5000 })
            } else {
                if (message.length > 0) {
                    sendData("sendbusinessmessage", {
                        message: message,
                        number: selectednumber,
                        job: currentjob
                    });
                } else {
                    if (locale == "de") {
                        $("#phone-constant-radio").html(localede.notempty);
                    } else {
                        $("#phone-constant-radio").html(locale.notempty);
                    }
                }
            };


            document.getElementById('phone-business-input-message').value = "";
        }
    }
}

$(document).on('click', '#pcimessage', function() {
    sendData("loadmessage", {
        number: selectednumber
    });
    lastcontact = 'message'
});

$(document).on('click', '#pcimessage2', function() {
    sendData("loadmessage", {
        number: selectednumber
    });
    lastcontact = 'message'
});

$(document).on('click', '#phone-chat-send', function() {
    var message = $('#phone-chat-input-message').val();
    let message1 = $('#phone-chat-input-message').val().toLowerCase();
    if (message1.indexOf('script') > -1 ||  message1.includes("<audio") == true || message1.includes("</audio") == true || message1.includes("html") == true || message1.includes("iframe") == true || message1.includes("src") == true || message1.includes("div") == true || message1.includes("div") == true || message1.includes("mp4") == true || message1.includes("<") == true || message1.includes(">") == true ) {
        sendData("notification", { text: 'Nice try d:^)', length: 5000 })
    } else {
        if (message.length > 0) {
            sendData("sendmessage", {
                message: message,
                number: selectednumber
            });
        } else {
            if (locale == "de") {
                $("#phone-constant-radio").html(localede.notempty);
            } else {
                $("#phone-constant-radio").html(locale.notempty);
            }
        }
    };

    document.getElementById('phone-chat-input-message').value = "";
});


$(document).on('click', '#phone-chat-placeicon', function() {
    sendData("sendgps", {
        number: selectednumber
    });
});

$(document).on('click', '#phone-chat-message-message-gps', function() {

    let x = $(this).data('x');
    let y = $(this).data('y');
    let z = $(this).data('z');


    sendData("setgps", {
        x: x,
        y: y,
        z: z
    });

});

function loadmessages(html, contactname) {
    $(".phone-chat").children().detach();
    $(".phone-chat").append(html);
    CloseAll();
    $(".phone-message").fadeIn(250);
    $(".phone-chat").scrollTop($(".phone-chat")[0].scrollHeight);
    privatmessage = selectednumber
    lastwindow = "privatmessage"
    lastcontact = "recentmessagemessage"
    if (darkmode == true) {
        Darkmode();
    }
    $("#phoneheadlinechat").html(contactname)
    lasthomebarwindow = "chat"
}

function refreshmessages(html, contactname) {
    $(".phone-chat").children().detach();
    $(".phone-chat").append(html);
    $(".phone-chat").scrollTop($(".phone-chat")[0].scrollHeight);
    privatmessage = selectednumber
    lastwindow = "privatmessage"
    lastcontact = "recentmessagemessage"
    if (darkmode == true) {
        Darkmode();
    }
    $("#phoneheadlinechat").html(contactname)
    lasthomebarwindow = "chat"
}

function loadrecentmessages(html) {
    $(".phone-recent-messages-sector").children().detach();
    $(".phone-recent-messages-sector").append(html);
    if (darkmode == true) {
        Darkmode();
    }
    $(".phone-applications").hide();
    $(".phone-call").hide();
    $(".phone-call-app").hide();
    $(".phone-call-ongoing").hide();
    $(".phone-applications").hide();
    $(".phone-app").hide();
    $(".phone-contacts").hide();
    $(".phone-contacts-information").hide();
    $(".phone-contacts-add").hide();
    $(".phone-contacts-edit").hide();
    $(".phone-recent-message").hide();
    $(".phone-message").hide();
    $("#phone-app-settings").hide();
    $(".phone-services").hide();
    $(".phone-businessapp").hide();
    $(".phone-radio").hide();
    $(".phone-recent-message").fadeIn(250);
    $("#phone-homebar").fadeIn(250);
    // lastcontact = 'recentmessage'
    $(".messagesettings").each(function() {
        $(this).hide()
    })
}

function reloadrecentmessages(html) {
    $(".phone-recent-messages-sector").children().detach();
    $(".phone-recent-messages-sector").append(html);
    if (darkmode == true) {
        Darkmode();
    }
    $(".messagesettings").each(function() {
        $(this).hide()
    })
}

var recentlastsettings = null
$(document).on('click', '.messagesettings', function() {
    recentlastsettings = $(this).data('number');
    sendData("print",{message: recentlastsettings})
    $(".phone-recent-message-settings").fadeIn(500)
});

$(document).on('click', '.phone-recent-messages-selection', function() {
    if (recentlastsettings == null ) {
        let number = $(this).data('number');
        selectednumber = $(this).data('number');
        sendData("loadmessage", {
            number: number
        });
        // lastcontact = 'recentmessagemessage'
    }
});

$(document).on('click', '#prmsclose', function() {
    recentlastsettings = null
    $(".phone-recent-message-settings").fadeOut(500)
});

$(document).on('click', '.deletecolumn', function() {
    $(".phone-recent-message-settings").fadeOut(500)
    sendData("deletechat", {
        number: recentlastsettings
    });
    recentlastsettings = null
});

const searchBar = document.forms['search-recentmessages'].querySelector('input');
searchBar.addEventListener('keyup', function(e) {
  const term = e.target.value.toLocaleLowerCase();
  const recentmessages = document.querySelectorAll('[id=prm-contactname]');
  var notAvailable = document.getElementById('notAvailable');
//   $("#titleMain").toggle($('input').val().length == 0);
  var hasResults = false;
  Array.from(recentmessages).forEach(function(book) {
    const title = book.textContent;
    if (title.toLowerCase().indexOf(term) != -1) {
        $(book).parent().show(0)
      hasResults = true;
    } else {
        $(book).parent().hide(0)
    //   book.style.display = 'none';
    }

    if (hasResults == false) {
        $("#notAvailable").show(0)
    } else {
      $("#notAvailable").hide(0)
    }
  });

});

var editmode = false
$(document).on('click', '#phone-recent-message-edit', function() {
    $(".messagesettings").each(function() {
        if (editmode == true) {
            sendData("print",{message: "Test1"})
            $(this).hide()
        } else {
            sendData("print",{message: "Test2"})
            $(this).show()
        }
    })

    if (editmode == true) {
        editmode = false
        $("#phone-recent-message-edit").html("Edit")
    } else {
        editmode = true
        $("#phone-recent-message-edit").html("Close")
    }

});
