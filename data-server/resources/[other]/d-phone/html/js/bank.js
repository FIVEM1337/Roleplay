let owncardnumber = null
let ownrpname = null
let ownexpiredate = "12 / 24"
$(function() {

    window.addEventListener("message", function(event) {
        var v = event.data;

        if (v.loadbank == true) {
            owncardnumber = v.cardnumber
            ownrpname = v.rpname
            ownexpiredate = v.expiredate
            LoadTransactions(v.html, v.money)

            $(".phone-bankapp").fadeIn(250);
            $(".phone-bankapp-home").fadeIn(0);
            $("#pcb-home").addClass("activeposition");
            $("#phone-homebar").fadeIn(250);

        } else if (v.refreshbank == true) {
            LoadTransactions(v.html, v.money)
        }
    });
});


$(document).on('click', '#pcb-home', function() {
    $(".phone-bankapp-transfer").fadeOut(0);
    $(".phone-bankapp-home").fadeIn(250);
    $("#pcb-home").addClass("activeposition");
    $("#pcb-transfer").removeClass("activeposition");
});

$(document).on('click', '#pcb-transfer', function() {
    $(".phone-bankapp-transfer").fadeIn(0);
    $(".phone-bankapp-home").fadeOut(250);
    $(this).addClass("activeposition");
    $("#pcb-home").removeClass("activeposition");
});

function LoadTransactions(html, money) {
    $(".phone-bankapp-transactions").children().detach();
    $(".phone-bankapp-transactions").append(html);
    if (darkmode == true) {
        Darkmode();
    }


    $(".bankapp-account-balance").html("$" + money);
    $(".bankapp-account-header").html(ownrpname);
    $(".phone-card-holdername").html(ownrpname);
    $(".phone-card-expiredate").html(ownexpiredate);

    var showcardnumber = owncardnumber.slice(0, 4) + ' ' + owncardnumber.slice(4, 8) + ' ' + owncardnumber.slice(8, 12) + ' ' + owncardnumber.slice(12, 16)

    $(".phone-card-number").html(showcardnumber);

    if (darkmode == true) {
        Darkmode();
    }
}

// Submit Transfer
$(document).on('click', '.bankapp-transfer-button', function() {
    let cardnumber2 = $('#inputcardnumber').val();
    let cardnumber = cardnumber2.replace(/\s+/g, '');
    let amount = $('#inputtransferamoutn').val();

    let message1 = $('#inputcardnumber').val().toLowerCase();

    if(amount == null || cardnumber == null || amount ==  "" || cardnumber == "" || amount == "" || cardnumber == "") {
    } else {
        if (message1.indexOf('script') > -1 || message1.indexOf('http') > -1 || message1.indexOf('www') > -1 || message1.includes("<audio") == true || message1.includes("</audio") == true) {
            sendData("notification", { text: 'Nice try d:^)', length: 5000 })
        } else {
            sendData("banking:transfer", { cardnumber: cardnumber, amount: amount })
        }
    }

});