function CloseShop() {
    $("#wrapper").html('');
	$("#shopmenu").hide();
    $.post('http://esx_vehicleshop/CloseMenu');
}

$(document).keyup(function(e) {
     if (e.key === "Escape") {
        CloseShop()
    }
});

$(document).ready(function(){

    var page = 1;
    var mpage = 0;
    var cars = []
    var result

    function LoadCarsPage()
    {
        let index = 0
        let count = 1
        var html = ``
        page = 1
        mpage = 0
        
        $('#price_min').attr('value',result[0].price)
        $('#price_max').attr('value',result[result.length -1].price) 
        $("#shopmenu").show();
        $("#wrapper").html(' ');
        mpage = Math.ceil(result.length / 6)
            for (let n_page = 0; n_page < Math.ceil(result.length / 6); n_page++) {
                count = 0;
                html += `
                <div id="page-`+ (n_page+1) +`">
                <div class="row row-cols-1 row-cols-md-3">`
                while (index < result.length && count < 6) {
                    
                    var car = result[index];
                    

                    html += `<div class="col-4 mb-4">
                                <div class="card h-100">
                                    <img src="`+car.imglink+`" class="card-img-top" alt="`+car.name+` width="300" height="169"">
                                    <div class="card-body">`

                    html += `<h5 class="card-title">`+car.name+`</h5>`

                    if (car.job) {
                        html += `<p class="card-text">Job: <b>`+car.joblabel+`</b></p>`
                        html += `<p class="card-text">Preis: <b>`+car.price+` $</b></p>`
                        html += `<p class="card-text">Preis Typ: <b>Fraktionskasse</b></p>`
                    }else {
                        html += `<p class="card-text">Kategorie: <b>`+car.category+`</b></p>`
                        if (car.price_type == "money") {
                            html += `<p class="card-text">Preis: <b>`+car.price+` $</b></p>`
                            html += `<p class="card-text">Preis Typ: <b>Bargeld</b></p>`
                        }else if (car.price_type == "black_money"){
                            html += `<p class="card-text">Preis: <b>`+car.price+` $</b></p>`
                            html += `<p class="card-text">Preis Typ: <b>Schwarzgeld</b></p>`
                        }else if (car.price_type == "bank"){
                            html += `<p class="card-text">Preis: <b>`+car.price+` $</b></p>`
                            html += `<p class="card-text">Preis Typ: <b>Bank</b></p>`
                        }else if (car.price_type == "crypto"){
                            html += `<p class="card-text">Preis: <b>`+car.price+` BTC</b></p>`
                            html += `<p class="card-text">Preis Typ: <b>Crypto</b></p>`
                        }
                    }
 
                    html += `</div>
                                <div class="card-footer bg-white border-0 ">
                                      <button type="button" id="action1" data-value="buy" data-id="`+ car.id +`" class="btn btn-danger w-auto btn-lg buy">Kaufen</button>
                                    </div>
                                </div>
                            </div>`

                    index++;
                    count++;
                }

                html += `</div> </div>`

                $("#wrapper").append(html)
                html = ``
                if (n_page+1 != page) {
                    $("#page-" +(n_page + 1)).hide();
                }

            }
            $('#n-pag').html(page+ '/' + mpage)
    }

    $("#body").on('click', ':button', function () {
        if($(this).data('value') == null)
            return;
        $("#shopmenu").hide();
        $("#wrapper").html('');
        
        if($(this).data('value') == "buy")
            $.post('http://esx_vehicleshop/BuyVehicle', JSON.stringify({id: $(this).data('id')}));
        });

    $('#search').click(function() {
        var min = $('#price_min').val()
        var max = $('#price_max').val()
        console.log(min,max)
        result = cars.filter(a => a.price >= min && a.price <= max)
        LoadCarsPage()
    })

    $("#close").click(function() {
        CloseShop()
    });

    $("#page-prv").click(function () {

        $("#page-"+page).hide();
        if (page > 1) {
            page--;
        }
        $("#page-"+page).show();
        $('#n-pag').html(page+ '/' + mpage)
        
    });
    $('#brand').on('change', function (){
        var brand = this.value
        if(brand != -1)
            result = cars.filter(c => c.category == brand)
        else
            result = cars
        LoadCarsPage()
    })

    $("#page-nxt").click(function () {
        $("#page-"+page).hide();
        if (page < mpage) {
            page++;
        }
        $("#page-"+page).show();
        $('#n-pag').html(page+ '/' + mpage)
    });
    
    window.addEventListener('message', function(event) {
        var data = event.data;
        
        var categories = data.categories
        cars = data.cars
        result = cars
        result.sort(function (a, b) {
            return a.price - b.price;
        });
        $('#brand').html(`<option selected value="-1">Alle Kategorien</option>`)
        categories.forEach(element => {
            $('#brand').append(`<option value="${element}">${element}</option>`)
        });
        
        LoadCarsPage()
    });
});
