$(function() {

    window.addEventListener("message", function(event) {
        var v = event.data;

        if (v.activemarket == true) {
            $("#dmarketicon").fadeIn(250);
        } else if (v.loadmarket == true) {
            LoadMarket(v.html)
        }
    });
});

function LoadMarket(html) {
    $("#dmarket-home").children().detach();
    $("#dmarket-home").append(html);
    

    $(".phone-dmarket").show(500)
    $("#dmarket-item").hide(0)
    $(".dmarket-item").hide(0)
    $("#dmarket-home").show(0)
    
    if (darkmode == true) {
        Darkmode();
    }
}

$(document).on('click', '.dmarket-product', function() {
    let name = $(this).data("name")
    let price = $(this).data("price")
    let stock = $(this).data("stock")
    let profit = $(this).data("profit")

    $("#dmarketitemlabel").html(name)
    // if (profit == "plus") {
    //     $("#dmarketprice").css({"color": "lightgreen"})
    // } else if (profit == "minus") {
    //     $("#dmarketprice").css({"color": "lightcoral"})
    // } else {
    //     if (darkmode == true) {
    //         $("#dmarketprice").css({"color": "white"})
    //     } else {
    //         $("#dmarketprice").css({"color": "black"})
    //     }
    // }
    $("#dmarketprice").html("$" + price)
    $("#dmarketstock").html(stock)
    $("#dmarket-home").hide()
    $("#dmarket-item").show(500)
    $(".dmarket-item").show(500)
});

$(document).on('click', '#dmarket-back', function() {
    $("#dmarket-home").show(500)
    $("#dmarket-item").hide(0)
});
