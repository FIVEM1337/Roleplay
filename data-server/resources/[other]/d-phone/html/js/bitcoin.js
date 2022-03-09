var bitcoinapploaded = false
var firsttimecrypto = false
var blocale = []
$(function() {
    window.addEventListener("message", function(event) {
        var v = event.data;

        if (v.activatebitcoinicon == true) {
            $("#bitcoinicon").fadeIn(250);
        } else if (v.showcrypto == true) {
            LoadHome(v.walletworth, v.bitcoinamount, v.bitcoinprice)
            LoadTransfer(v.walletid, v.historyhtml)
            SetBitcoinLocales(v.locales)
            if (darkmode == true) {
                Darkmode();
            }
            if (bitcoinapploaded == false && firsttimecrypto == true) {
                $(".phone-applications").hide();
                $("#phone-app-bitcoin").show(500)
                if (darkmode == true) {
                    Darkmode();
                
                } 
                $("#phone-homebar").show(500)
                $("#bitcoin-home").addClass("purplecolor")
            }

            bitcoinapploaded = true

        }  else if (v.setBitcoinLocales == true) {
            SetBitcoinLocales(v.locales)
        } else if (v.refreshusergraph == true) {
            Refreshusergraph(v.TimeData, v.PriceData)
        } else if (v.refreshmarketgraph == true) {
            Refreshmarketgraph(v.TimeData, v.PriceData)
        } else if (v.updateminedamount) {
            Updateminedamount(v.amount)
        }
    });
});

function LoadHome(walletworth, bitcoinamount, bitcoinprice) {
    $('#totalbalance').html(walletworth + "$")
    $('#totalbitcoins').html(bitcoinamount)
    $('#bitcoinprice').html(bitcoinprice + "$")
}

function LoadTransfer(walletid, historyhtml) {
    $("#phone-app-bitcoin-tranfer-id").html(walletid)

    $("#phone-app-bitcoin-tranfer-history").children().detach();
    $("#phone-app-bitcoin-tranfer-history").append(historyhtml);

    if (darkmode == true) {
        Darkmode();
    }
}


function SetBitcoinLocales(blocale2) {
    blocale = blocale2
    $("#phone-app-bitcoin-headline").html(blocale.wallet)
    $("#localebitcoinprice").html(blocale.bitcoinprice)
    $("#localebalance").html(blocale.balance)
    $("#localebitcoins").html(blocale.bitcoins)

    // Shop
    $("#phone-app-bitcoin-shop-buybutton").html(blocale.amount)
    $("#phone-app-bitcoin-shop-buybutton").html(blocale.buylabel)
    $("#phone-app-bitcoin-shop-sellbutton").html(blocale.selllabel)

    // Transfer
    $("#phone-app-bitcoin-tranfer-idlabel").html(blocale.yourwalletid)
    $("#phone-app-bitcoin-tranfer-receiveridlabel").html(blocale.receiverwalletid)
    $("#phone-app-bitcoin-tranfer-amountlabel").html(blocale.amount)

    $("#phone-app-bitcoin-tranfer-label").html(blocale.transfer)
    $("#phone-app-bitcoin-tranfer-historyheadline").html(blocale.history)

}

// Footer
var open = "phone-app-bitcoin-home"
var openid = "bitcoin-home"
var lastdirection = "left"
$(document).on("click", ".phone-bitcoin-footer-item", function() {
	var mainscreen = $(this).data("mainscreen");
	var direction = $(this).data("direction");

    if (open == null) {
		$("#"+mainscreen).show(500)
		open = mainscreen
	} else {
		if (open != mainscreen) {
            $("#bitcoin-home").removeClass("purplecolor")
            $("#bitcoin-market").removeClass("purplecolor")
            $("#bitcoin-transaction").removeClass("purplecolor")
        
            if (direction == "right") {
                $("#" +open).animate({left: '-100%'}, 500);
                $("#"+mainscreen).css({"left": '100%', "display": "block"});
                $("#"+mainscreen).animate({left: '0%'}, 500);
                open = mainscreen
              
                $("#phone-app-bitcoin-headline").html(blocale.transfer)
                openid = "bitcoin-transaction"
            }
            if (direction == "mid") {
                if (lastdirection == "left") {
                    $("#" +open).animate({left: '-100%'}, 500);
                    $("#"+mainscreen).css({"left": '100%', "display": "block"});
                    $("#"+mainscreen).animate({left: '0%'}, 500);
                    open = mainscreen
                } else {
                    $("#" +open).animate({left: '100%'}, 500);

                    $("#"+mainscreen).css({"left": '-100%', "display": "block"});
                    $("#"+mainscreen).animate({left: '0%'}, 500);
    
                    open = mainscreen
                }
                $("#phone-app-bitcoin-headline").html(blocale.market)
                openid = "bitcoin-market"
            }
            if (direction == "left") {
                $("#" +open).animate({left: '100%'}, 500);              
                $("#"+mainscreen).css({"left": '-100%', "display": "block"});
                $("#"+mainscreen).animate({left: '0%'}, 500);
                open = mainscreen
                $("#phone-app-bitcoin-headline").html(blocale.wallet)
                openid = "bitcoin-home"
            }
       
            $("#" +openid).addClass("purplecolor")
            lastdirection = direction
		}
	}
});

function addData(chart, label, data) {
    chart.data.labels.push(label);
    chart.data.datasets.forEach((dataset) => {
        dataset.data.push(data);
    });
    chart.update('none');
}

function removeData(chart) {
    chart.data.labels.pop();
    chart.data.datasets.forEach((dataset) => {
        dataset.data.pop();
    });
    chart.update();
}



var bfirsttime = true
var myChart
function Refreshusergraph(TimeData, PriceData) {
    print("refreshjs")
    if (bfirsttime == true)  {
        var ctx = document.getElementById('homeChart').getContext('2d');
        myChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: TimeData,
                datasets: [{
                    label: "Bitcoin in $",
                    data: PriceData,
                    backgroundColor: [
                        'rgba(0, 255, 0, 0.2)'
                    ],
                    borderColor: [
                        'rgba(0, 255, 0, 1)'
                    ],
                    borderWidth: 1,
                    fill: true, 
                    tension: 0.1
                },
            ]
            },
            options: {
                bezierCurve : true,
                
                scales: {
                    y: {
                        display: false,
                        beginAtZero: false,
                        grid: {
                            display: false
                        },
                    },
                    x: {
                        autoSkip: true,
                        autoSkipPadding: 2,
                        grid: {
                            display: false
                        },
                    }
                },
                elements: {
                    point:{
                        radius: 0
                    }
                },
                legend: {
                    display: false
                 },
                 tooltips: {
                    enabled: false
                 },
                 plugins:{   
                    legend: {
                        display: false
                    },
                },
            }
        });
        bfirsttime = false
    } else {
        var chart = myChart
        $.each( TimeData, function( key, value ) {
            addData(chart, value, PriceData[key])
          });
    }
  
}

var bfirsttimemarket = true
var marketChart
function Refreshmarketgraph(TimeData, PriceData) {

    if (bfirsttimemarket == true)  {
        var ctx = document.getElementById('marketChart').getContext('2d');
        marketChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: TimeData,
                datasets: [{
                    label: "Bitcoin in $",
                    data: PriceData,
                    backgroundColor: [
                        'rgba(0, 255, 0, 0.2)'
                    ],
                    borderColor: [
                        'rgba(0, 255, 0, 1)'
                    ],
                    borderWidth: 1,
                    fill: true, 
                    tension: 0.1
                },
            ]
            },
            options: {
                bezierCurve : true,
                
                scales: {
                    y: {
                        display: false,
                        beginAtZero: false,
                        grid: {
                            display: false
                        },
                    },
                    x: {
                        autoSkip: true,
                        autoSkipPadding: 2,
                        grid: {
                            display: false
                        },
                    }
                },
                elements: {
                    point:{
                        radius: 0
                    }
                },
                legend: {
                    display: false
                 },
                 tooltips: {
                    enabled: false
                 },
                 plugins:{   
                    legend: {
                        display: false
                    },
                },
            }
        });
        bfirsttimemarket = false
    } else {
        var chart = marketChart
        $.each( TimeData, function( key, value ) {
            addData(chart, value, PriceData[key])
          });
    }
}

$(document).on("click", "#phone-app-bitcoin-shop-buybutton", function() {
    var amount = $("#phone-app-bitcoin-shop-amount").val()

    sendData("bitcoin:martket:bitcoin",{
        amount: amount,
        state: "buy"
    })
});

$(document).on("click", "#phone-app-bitcoin-shop-sellbutton", function() {
    var amount = $("#phone-app-bitcoin-shop-amount").val()

    sendData("bitcoin:martket:bitcoin",{
        amount: amount,
        state: "sell"
    })
});

$(document).on("click", "#phone-app-bitcoin-tranfer-label", function() {
    var receiverwallet = $("#phone-app-bitcoin-tranfer-receiverid").val()
    var amount = $("#phone-app-bitcoin-tranfer-amount").val()

    sendData("bitcoin:transfer",{
        amount: amount,
        receiverwallet: receiverwallet
    })
});