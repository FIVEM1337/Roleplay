$("#box").hide();

window.onload = function(e) {
    window.addEventListener('message', function(event) {
        let data = event.data
        $("#box").show();
        document.getElementById("title").textContent = data.title;
        document.getElementById("name").textContent = data.job;
    })
}

$("#submit").click(function() {
    $("#box").hide();

    $.post("http://esx_frakinvite/join", JSON.stringify({
        job: document.getElementById("name").textContent
    }));
});


$("#cancel").click(function() {
    $("#box").hide();
    $.post("http://esx_frakinvite/exit", JSON.stringify({
        job: document.getElementById("name").textContent
    }));
});