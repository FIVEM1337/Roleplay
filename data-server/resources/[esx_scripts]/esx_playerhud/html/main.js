
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
		}else if (event.data.action == "setTalking"){
			setTalking(event.data.value)
		}else if (event.data.action == "setVoiceRange"){
			setVoiceRange(event.data.range, event.data.muted)
		}else if (event.data.action == "toggle"){
			if (event.data.show){
				document.getElementById("ui").classList.toggle("show",true)
			} else{
				document.getElementById("ui").classList.toggle("show",false)
			}
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
	$('#water .bg').css('height', thirst+'%')
	$('#drunk .bg').css('height', stress+'%');
	if (stress > 0){
		$('#drunk').show();
	}else{
		$('#drunk').show();
	}
}



function setVoiceRange(range, muted){
	var color;
	var speaker;

	if (muted){
		color = "#cc0000";
	}else{
		color = "#81C784"
	}

	if (range == 3.5){
		speaker = 1;
	}else if (range == 8){
		speaker = 2;
	}else if (range == 15){
		speaker = 3;
	}else if (range == 32){
		speaker = 4;

	}
	$('#voice .bg').css('background-color', color);
	$('#voice img').attr('src', 'img/speaker'+speaker+'.png');
}	

function setTalking(value){
	if (value){
		$('#voice').css('border', '3px solid #03A9F4')
	}else{
		$('#voice').css('border', 'none')
	}
}
