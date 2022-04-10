
var rgbStart = [139,195,74]
var rgbEnd = [183,28,28]

$(function(){
	window.addEventListener('message', function(event) {
		if (event.data.action == "setValue"){
			if (event.data.key == "job"){
				setJobIcon(event.data.icon)
			}
			setValue(event.data.key, event.data.value)
		}else if (event.data.action == "updateStatus"){
			updateStatus(event.data.hunger, event.data.thirst, event.data.stress);
		}else if (event.data.action == "updateStatus2"){
			updateStatus2(event.data.health, event.data.armor);
		}else if (event.data.action == "setVoice"){
			setVoice(event.data)
		}else if (event.data.action == "show"){
			document.getElementById("main").classList.toggle("show",event.data.show)
		}


		
	});
});

function setValue(key, value){
	$('#'+key+' span').html(value)

}

function setJobIcon(value){
	$('#job img').attr('src', 'img/jobs/'+value+'.png')
}

function updateStatus(hunger, thirst, stress){
	$('#hunger .bg').css('height', hunger+'%');
	$('#water .bg').css('height', thirst+'%');
	$('#drunk .bg').css('height', stress+'%');
}


function updateStatus2(health, armor){
	$('#health .bg').css('width', health+'%');
	$('#armor .bg').css('width', armor+'%');
}

function setVoice(data){
	var range = data.range;
	var muted = data.muted;
	var talking = data.talking;
	var contented = data.connected;

	if (contented){
		if (muted){
			$('#voice img').attr('src', 'img/voice/muted.png');
			$('#range').css('background-color', "#F44336");
		}else{
			if (range == 3.5){
				$('#range').css('background-color', "#81C784");
			}else if (range == 8){
				$('#range').css('background-color', "#FDD835");
			}else if (range == 15){
				$('#range').css('background-color', "#FF8800");
			}else if (range == 32){
				$('#range').css('background-color', "#F44336");
			}
			if (talking){
				$('#voice img').attr('src', 'img/voice/talking.png');
			}else{
				$('#voice img').attr('src', 'img/voice/not_talking.png');
			}
		}
	}else{
		$('#voice img').attr('src', 'img/voice/not_connected.png');
		$('#range').css('background-color', "#F44336");
	}
}
