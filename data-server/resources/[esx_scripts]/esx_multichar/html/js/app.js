$(".character-box").hover(
    function() {
        $(this).css({
            "background": "rgba(44, 51, 69, 0.8)",
            "transition": "200ms",
        });
    }, function() {
        $(this).css({
            "background": "rgba(254, 254, 254, 0.8)",
            "transition": "200ms",          
        });
    }
);

$(".character-box").click(function () {
    $(".character-box").removeClass('active-char');

    $(this).addClass('active-char');
    $(".character-buttons").css({"display":"flex"});
    if ($(this).attr("data-isnew") === "false") {
        $("#delete").css({"display":"flex"});
    } else {
        $("#delete").css({"display":"none"});
    }
});

$("#play-char").click(function () {
    $.post("http://esx_multichar/CharacterChosen", JSON.stringify({
        charid: $('.active-char').attr("data-charid"),
        isnew: $('.active-char').attr("data-isnew"),
    }));
    Kashacter.CloseUI();
});

$("#deletechar").click(function () {
    $.post("http://esx_multichar/DeleteCharacter", JSON.stringify({
        charid: $('.active-char').attr("data-charid"),
    }));
    Kashacter.CloseUI();
});

(() => {
    Kashacter = {};

    Kashacter.ShowUI = function(data) {
        $('.main-container').css({"display":"block"});
        $('.bg').css({"display":"block"});
        if(data.characters !== null) {
            $.each(data.characters, function (index, char) {
                if (char.charid !== 0) {
                    var charid = char.identifier.charAt(0);
                    $('[data-charid=' + charid + ']').html('<h3 class="character-fullname">'+ char.firstname +' '+ char.lastname +'</h3><div class="character-info"><p class="character-info-work"><strong>Job: </strong><span>'+ char.job +'</span></p><p class="character-info-money"><strong>Bargeld: </strong><span>'+ char.money + '$' +'</span></p><p class="character-info-bank"><strong>Bank: </strong><span>'+ char.bank  +'</span></p></div>').attr("data-isnew", false);

                }
            });
        }
    };

    Kashacter.CloseUI = function() {
        $('.main-container').css({"display":"none"});
        $('.BG').css({"display":"none"});
        $(".character-box").removeClass('active-char');
        $("#delete").css({"display":"none"});
		$(".character-box").html('<h3 class="character-fullname"><i class="fas fa-plus"></i></h3><div class="character-info"><p class="character-info-new">Neuen Charakter erstellen</p></div>').attr("data-isnew", true);
    };
    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case 'openui':
                    Kashacter.ShowUI(event.data);
                    break;
            }
        })
    }

})();