$(document).keyup(function (e) {
	if (e.key === 'Escape') {
		CloseShop();
	}
});



function CloseShop() {
	$('body').fadeOut(100);
	$('.items').empty();
	$('.container').fadeOut(100);
	$('.modal').removeClass('visible');
	$.post('http://esx_weaponshop/focusOff');
}

document.addEventListener('DOMContentLoaded', function () {
	$('.container').hide();
});

function buyItem(item, zone) {
	
	$.post(
		'http://esx_weaponshop/buyItem',
		JSON.stringify({
			item: item,
			zone: zone,
		})
	);
}

function showModal(item, zone, itemLabel, desc, price) {
	$('.items').click(function () {
		$('.modal').addClass('visible');
		$('.modalimage').html(
			`<img src="./img/` +
				item +
				`.png"><div class="itemName"><p class="modal-label">` +
				itemLabel +
				`</p><span class="modal-price">$` +
				price +
				`</span></div><p class="modal-desc">` +
				desc +
				`</p>`
		);
		$('.btn-open').html(
			`<button class="btn-1" onclick="buyItem('` +
				item +
				`', '` +
				zone +
				`')"></button>`
		);
	});

	$(document).click((event) => {
		if ($(event.target).closest('.btn-1').length) {
			$('.modal').removeClass('visible');
		}
	});
}


$(document).ready(function(){
	var result
	var category = null

	function LoadItems()
	{

		$('.items').empty();
		let index = 0	

		
		while (index < result.length) {
			var element = result[index];

			if (category == null)
				AppendItem(element)
			else if (category == -1)
				AppendItem(element)

			else if (element.category == category)
				AppendItem(element)

			index++;
		}

		function AppendItem(element)
		{
			if (element.job)
				$('.items').append(
					`
					<div class="item2" onclick="showModal('` +
						element.item +
						`', '` +
						element.zone +
						`', '` +
						element.label +
						`', '` +
						element.desc +" " + element.job +
						`', '` +
						element.price +
						`')">
						<img class="img-item" src="./img/` +
						element.item +
						`.png">
							<div class="label">
								<p class="itemString2">` +
						element.label +
						`</p>
								<p class="itemPrice"><span class="bg-price">$` +
						element.price +
						`</span></p>
							</div>
					</div>
				`
				);
			else
				$('.items').append(
					`
					<div class="item" onclick="showModal('` +
						element.item +
						`', '` +
						element.zone +
						`', '` +
						element.label +
						`', '` +
						element.desc +
						`', '` +
						element.price +
						`')">
						<img class="img-item" src="./img/` +
						element.item +
						`.png">
							<div class="label">
								<p class="itemString">` +
						element.label +
						`</p>
								<p class="itemPrice"><span class="bg-price">$` +
						element.price +
						`</span></p>
							</div>
					</div>
				`
				);

		}

	}

	$('#brand').on('change', function (){
		category = this.value
		LoadItems()
	})


	window.addEventListener('message', function (event) {
		var data = event.data;

		var categories = data.categories
		items = data.items
		result = items


		if (data.clear == true) {
			$('.items').empty();
		}

		if (data.display == true) {
			$('body').show();
			$('body').fadeIn(100);
			$('.container').show();
		}

		if (data.display == false) {
			$('body').fadeOut(100);
			$('.container').fadeOut(100);
		}

		$('#brand').html(`<option selected value="-1">All the brands</option>`)
		categories.forEach(element => {
				$('#brand').append(`<option value="${element}">${element}</option>`)
		});


		LoadItems()

	});

});
