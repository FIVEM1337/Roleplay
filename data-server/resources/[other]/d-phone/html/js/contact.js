
var currentpage = null
var lastpage = null
var prepage = null

var selectednumber = null
var selectedname = null
var selectedfavourit = null

var canback = true

$(function() {
    window.addEventListener("message", function(event) {
        var v = event.data;

        if (v.loadcontacts == true) {
            loadcontacts(v.html)
        } else if (v.hardshowcontacts == true) {
            hardloadcontacts(v.html)
        } else if (v.showContactPage == true) {
            showContactPage()
        } else if (v.editcontactsuccess == true ) {
            canback = true
            $(lastpage).css({
                "display": "block",
            })
            $(currentpage).animate({
                "margin-left": "-30vh",
            }, 450)
            $(lastpage).animate({
                "margin-left": "0vh",
            }, 400)
            setTimeout(function() {
                $(currentpage).css({
                    "display": "none",
                })
                if (prepage != null) {
                    currentpage = lastpage
                    lastpage = prepage
                  }
              }, 500);

              selectednumber = v.number
              selectedname =  v.name
              // $("#phone-app-contact").hide(0)
              $("#phone-app-contact-page-name").html( v.name)
              $("#phone-app-contact-page-number").html( v.number)
        }
    });
});

function loadcontacts(html) {
    $("#phone-app-contact-content").children().detach();
    $("#phone-app-contact-content").append(html);
    $("#phone-app-contact").show(500)
    if (darkmode == true) {
        Darkmode();
    }

}

function showContactPage() {
    $("#phone-app-contact").show(500)
    if (darkmode == true) {
        Darkmode();
    }
}

function hardloadcontacts(html) {
    $("#phone-app-contact-content").children().detach();
    $("#phone-app-contact-content").append(html);
    $("#phone-app-contact").show(500)
    if (darkmode == true) {
        Darkmode();
    }
    lastpage = "#phone-app-contact"
    canback = true

    $(lastpage).css({
        "display": "block",
    })
    $(currentpage).animate({
        "margin-left": "-30vh",
    }, 450)
    $(lastpage).animate({
        "margin-left": "0vh",
    }, 400)
    setTimeout(function() {
        $(currentpage).hide(0)
        if (prepage != null) {
            currentpage = lastpage
            lastpage = prepage
          }
      }, 500);
}

$(document).on('click', '#phone-app-contact-div', function() {
    var name = $(this).data('name');
    var number = $(this).data('number');
    var favourit = $(this).data('favourit');

    selectednumber = number
    selectedname = name
    selectedfavourit = favourit
    // $("#phone-app-contact").hide(0)
    
    $("#phone-app-contact-page-name").html(name)
    $("#phone-app-contact-page-number").html(number)

    currentpage = "#phone-app-contact-page"
    lastpage = "#phone-app-contact"
    canback = true

    AppSlideIn(currentpage, lastpage)

    if (favourit == "1") {
        $("#phone-app-contact-page-favourit").addClass('favouriticon');
        $("#phone-app-contact-page-favourit").removeClass('purplecolor');
    } else {
        // if ($("#phone-app-contact-page-favourit").hasCass('favouriticon')) {
            $("#phone-app-contact-page-favourit").removeClass('favouriticon');
            $("#phone-app-contact-page-favourit").addClass('purplecolor');
        // }
    }

});

$(document).on('click', '#headerback2', function() {
    if (canback == true ) {
        if (lastwindow == "case") {
            Casepreview(oldcase, oldmodel)
            lastwindow = "settings"
        } 
        
        $(lastpage).css({
            "display": "block",
        })
        $(currentpage).animate({
            "margin-left": "-30vh",
        }, 450)
        $(lastpage).animate({
            "margin-left": "0vh",
        }, 400)
        setTimeout(function() {
            $(currentpage).hide(0)
            if (prepage != null) {
                currentpage = lastpage
                lastpage = prepage
              }
          }, 500);
    }



});

function AppSlideIn(currentpage, lastpage) {

    $(currentpage).css({
        "display": "block",
        "margin-left": "-30vh",
    })
    $(lastpage).animate({
        "margin-left": "30vh",
    }, 450)
    $(currentpage).animate({
        "margin-left": "0vh",
    }, 400)
}

$(document).on('click', '#phone-app-contact-page-favourit', function() {
    if ($("#phone-app-contact-page-favourit").hasClass('favouriticon')) {
        $("#phone-app-contact-page-favourit").removeClass('favouriticon');
    } else {
        $("#phone-app-contact-page-favourit").addClass('favouriticon');
    }
});


// Add Contact
$(document).on('click', '#phone-app-contact-page-add', function() {
    currentpage = "#phone-app-contact-new"
    lastpage = "#phone-app-contact"
    
    canback = true

    AppSlideIn(currentpage, lastpage)
});

const inputHandler = function(e) {
    result.innerHTML = e.target.value;
  }
 
const inputHandler2 = function(e) {
    result2.innerHTML = e.target.value;
    result.innerHTML = $("#phone-app-contact-name").val()
}

const source = document.getElementById('phone-app-contact-name');
const result = document.getElementById('phone-app-newcontact');

const source2 = document.getElementById('phone-app-contact-lastname');
const result2 = document.getElementById('phone-app-newlastnamecontact');

source.addEventListener('input', inputHandler);
source.addEventListener('input', inputHandler);
source.addEventListener('propertychange', inputHandler); 

source2.addEventListener('input', inputHandler2);
source2.addEventListener('propertychange', inputHandler2); 

// Save Button
$(document).on('click', '#phone-app-contact-new-savebutton', function() {
    var firstname = $("#phone-app-contact-name").val()
    var lastname = $("#phone-app-contact-lastname").val()
    var number = $("#phone-app-contact-phonenumber").val()
    var name = firstname + ' ' + lastname
    if (name.indexOf('script') > -1 ||  name.includes("<audio") == true || name.includes("</audio") == true || name.includes("html") == true || name.includes("iframe") == true || name.includes("src") == true || name.includes("div") == true || name.includes("div") == true || name.includes("mp4") == true || name.includes("<") == true || name.includes(">") == true ) {
        sendData("notification", { text: 'Nice try d:^)', length: 5000 })
    } else {
        if (number.indexOf('script') > -1 || number.indexOf('http') > -1 || number.indexOf('www') > -1 || number.includes("<audio") == true || number.includes("</audio") == true) {
            sendData("notification", { text: 'Nice try d:^)', length: 5000 })
        } else {
            sendData("addcontact", {
                name: name,
                number: number
            });
        }
    }
});

// Edit Contact
$(document).on('click', '#phone-app-contact-page-edit', function() {
    prepage = "#phone-app-contact"
    currentpage = "#phone-app-contact-edit"
    lastpage = "#phone-app-contact-page"

    var name = selectedname
    var number = selectednumber
    print(name)
    if (hasWhiteSpace(name) == true) {
        var namesplit = name.split(" ")
        $('#phone-app-contact-edit-name').val(namesplit[0]);
        $('#phone-app-contact-edit-lastname').val(namesplit[1]);
    } else {
        $('#phone-app-contact-edit-name').val(name);
    }
  

    $('#phone-app-edit-newcontact').html(name);    

    $('#phone-app-contact-edit-phonenumber').val(number);
    AppSlideIn(currentpage, lastpage)
});

function hasWhiteSpace(s) {
    return (/\s/).test(s);
  }

const inputVorname = function(e) {
    vornameinput.innerHTML = e.target.value;
    nachnameinput.innerHTML = nachnameinput.innerHTML
  }
 
const inputNachname = function(e) {
    nachnameinput.innerHTML = e.target.value;
    vornameinput.innerHTML = $("#phone-app-contact-edit-name").val()
}

const vornameinputsource = document.getElementById('phone-app-contact-edit-name');
const vornameinput = document.getElementById('phone-app-edit-newcontact');

const nachnameinputsource = document.getElementById('phone-app-contact-edit-lastname');
const nachnameinput = document.getElementById('phone-app-edit-newlastnamecontact');

vornameinputsource.addEventListener('input', inputVorname);
vornameinputsource.addEventListener('propertychange', inputVorname); 

nachnameinputsource.addEventListener('input', inputNachname);
nachnameinputsource.addEventListener('propertychange', inputNachname); 

$(document).on('click', '#phone-app-contact-new-editbutton', function() {
    var firstname = $("#phone-app-contact-edit-name").val()
    var lastname = $("#phone-app-contact-edit-lastname").val()
    var number = $("#phone-app-contact-edit-phonenumber").val()
    var name = firstname + ' ' + lastname

    if (name.indexOf('script') > -1 ||  name.includes("<audio") == true || name.includes("</audio") == true || name.includes("html") == true || name.includes("iframe") == true || name.includes("src") == true || name.includes("div") == true || name.includes("div") == true || name.includes("mp4") == true || name.includes("<") == true || name.includes(">") == true ) {
        sendData("notification", { text: 'Nice try d:^)', length: 5000 })
    } else {
        if (number.indexOf('script') > -1 || number.indexOf('http') > -1 || number.indexOf('www') > -1 || number.includes("<audio") == true || number.includes("</audio") == true) {
            sendData("notification", { text: 'Nice try d:^)', length: 5000 })
        } else {
            sendData("editcontact", {
                name: name,
                name2: selectedname,
                number: number,
                number2: selectednumber,
            });
            print(name)
            canback = false
        }
    }
});

// Favourit function
$(document).on('click', '#phone-app-contact-page-favourit', function() {

    sendData("addcontactfavourit", {
        name: selectedname,
        number: selectednumber
    });

    if (selectedfavourit == "1") {
        $(this).removeClass('favouriticon');
        $(this).addClass('purplecolor');
        selectedfavourit = "0"
    } else {
        // if ($("#phone-app-contact-page-favourit").hasCass('favouriticon')) {
            $(this).removeClass('purplecolor');
            $(this).addClass('favouriticon');
            selectedfavourit = "1"
        // }
    }
});

// Delete Contact
$(document).on('click', '#phone-app-contact-page-delete', function() {
    if (selectedname != null) {
        sendData("deletecontact", {
            name: selectedname,
            number: selectednumber
        });

        selectedname = null
        selectednumber = null
        canback = false
        AppSlideIn(currentpage, lastpage)
    }
});

$(document).on('click', '#phone-app-contact-edit-delete', function() {
    if (selectedname != null) {
        sendData("deletecontact", {
            name: selectedname,
            number: selectednumber
        });

        selectedname = null
        selectednumber = null
        canback = false
        AppSlideIn(currentpage, lastpage)
    }
});

// Share contact
$(document).on('click', '#phone-app-contact-page-sharecontact', function() {
    if (selectedname != null) {
        sendData("sharecontact", {
            name: selectedname,
            number: selectednumber
        });

        selectedname = null
        selectednumber = null

        AppSlideIn(currentpage, lastpage)
    }
});

// GPS
$(document).on('click', '#phone-app-contact-page-sendlocatoin', function() {
    sendData("sendgps", {
        number: selectednumber
    });

    // AppSlideIn(currentpage, lastpage)
});

// Search bar
const contactsearchBar = document.forms['phone-app-contact-page-searchbar'].querySelector('input');
contactsearchBar.addEventListener('keyup', function(e) {
  const term = e.target.value.toLocaleLowerCase();
  const recentmessages = document.querySelectorAll('[id=phone-contact-name]');
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

// Message
$(document).on('click', '#phone-app-contact-page-message', function() {
    sendData("loadmessage", {
        number: selectednumber
    });
    lastcontact = 'message'
});
// Call
$(document).on('click', '#phone-app-contact-page-call', function() {
    var element = document.getElementById("phone-call-outgoing-caller");
    element.innerHTML = selectedname
    $(".phone-call").hide();
    $(".phone-all-call-sector").hide()
    $("#phone-app-contact-page").hide();
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


    sendData("startcall", { number: selectednumber, contact: selectedname });
});