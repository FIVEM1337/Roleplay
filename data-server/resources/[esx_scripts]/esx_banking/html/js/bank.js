$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type === "openGeneral"){
            $('body').fadeIn(500);
        } else if(event.data.type === "balanceHUD") {
            var balance = event.data.balance;
            $('.esx_banking-creditcard-footer-cardholder').html(event.data.player);
            $('.vb-balance-balance').html("$ "+balance);
            $('.esx_banking-tarjetas-mycardcontainer-balance').html("$ "+balance);
            $('.esx_banking-tarjetas-rigthbar-balance').html("$ "+balance);
            $('.esx_banking-myaccount-balance-balance').html("$ "+balance);
            $('.esx_banking-myaccount-faq-balance').html("$ "+balance);
            if (balance.toString().length >= Number(6)) {
                document.getElementById("esx_banking-tarjetas-mycardcontainer-balance").style.fontSize = "28px"
                document.getElementById("esx_banking-tarjetas-rigthbar-balance").style.fontSize = "25px"
                document.getElementById("esx_banking-depositcontainer-balance").style.fontSize = "25px"
                document.getElementById("esx_banking-transferir-container-balance").style.fontSize = "25px"
                document.getElementById("esx_banking-transferir-myaccount-balance").style.fontSize = "25px"
            }
            var playername = event.data.player
            $('.esx_banking-creditcard-cardholder').html(playername);
            var address = event.data.address
            $('.esx_banking-myaccount-info-address').html('<i class="fal fa-map-marker-alt"></i>&nbsp;&nbsp;&nbsp;</i>Adresse:&nbsp;&nbsp;'+address+'</span>');
            var walletid1 = event.data.cardnumber1
            var walletid2 = event.data.cardnumber2
            var walletid3 = event.data.cardnumber3
            var walletid4 = event.data.cardnumber4
    
            $('.esx_banking-accountdiv-accountnumber').html('****' + " " +walletid4+'');
            $('.esx_banking-creditcard-number').html(''+walletid1+ " " +walletid2+ " " +walletid3+ " " +walletid4+'');
            $('.esx_banking-myaccount-info-walletid').html('<i class="fal fa-wallet"></i>&nbsp;&nbsp;&nbsp;</i>Konto Nr:&nbsp;&nbsp;'+walletid1+ " " +walletid2+ " " +walletid3+ " " +walletid4+'</span>');
        } else if (event.data.type === "closeAll"){
            $('body').fadeOut(500);
        }
    });
});

$(document).on('click','#inicio',function(){
    hideall();
    $(".esx_banking-container-inicio").fadeIn(500);
})

$(document).on('click','#mycards',function(){
    hideall();
    $(".esx_banking-bigcontainertarjetas").fadeIn(500);
})

$(document).on('click','#meterpastica',function(){
    hideall();
    $(".esx_banking-bigcontainerdepositar").fadeIn(500);
})

$(document).on('click','#depositar',function(){
    hideall();
    $(".esx_banking-bigcontainerdepositar").fadeIn(500);
})

$(document).on('click','#transfer',function(){
    hideall();
    $(".esx_banking-bigcontainertransfer").fadeIn(500);
})

$(document).on('click','#myaccount',function(){
    hideall();
    $(".esx_banking-bigcontainermyaccount").fadeIn(500);
})

$(document).on('click','#faq',function(){
    hideall();
    $(".esx_banking-bigcontainerfaq").fadeIn(500);
})

$(document).on('click','#closebanking',function(){
    $('body').fadeOut(500);
    $.post('http://esx_banking/NUIFocusOff', JSON.stringify({}));
})

$(document).on('click','#withdraw',function(e){
    e.preventDefault();
    $.post('http://esx_banking/withdraw', JSON.stringify({
        amountw: $("#withdrawnumber").val()
    }));
    $('body').fadeOut(500);
    $.post('http://esx_banking/NUIFocusOff', JSON.stringify({}));
})

$(document).on('click','#depositarpasta',function(e){
    e.preventDefault();
    $.post('http://esx_banking/deposit', JSON.stringify({
        amount: $("#cantidaddepositar").val()
    }));
    $('body').fadeOut(500);
    $.post('http://esx_banking/NUIFocusOff', JSON.stringify({}));
})

$(document).on('click','#transferirpasta',function(e){
    e.preventDefault();
    $.post('http://esx_banking/transfer', JSON.stringify({
        to: $("#iddestinatario").val(),
        amountt: $("#cantidadtransfer").val()
    }));
    $('body').fadeOut(500);
    $.post('http://esx_banking/NUIFocusOff', JSON.stringify({}));
})

function hideall() {
    $(".esx_banking-container-inicio").hide();
    $(".esx_banking-bigcontainertarjetas").hide();
    $(".esx_banking-bigcontainerdepositar").hide();
    $(".esx_banking-bigcontainertransfer").hide();
    $(".esx_banking-bigcontainermyaccount").hide();
    $(".esx_banking-bigcontainerfaq").hide();
}

document.onkeyup = function(data){
    if (data.which == 27){
        $('body').fadeOut(500);
        $.post('http://esx_banking/NUIFocusOff', JSON.stringify({}));
    }
}