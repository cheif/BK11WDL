Array.prototype.sum = function(){
	return this.reduce(function(a,b){ return a+b;});
}

var currentplayer = 0;
var multiplier = 1;
var accumlatedscore = [];

$(document).ready(function(){
	$('#multipliers .btn').click(function(){
		var value = parseInt($(this).attr('value'));
		if(value != 0){
			multiplier = value;
		}
		else{
			setscore(0);
		}
	});

	$('#scorewrapper .btn').click(function(){
		var value = parseInt($(this).attr('value'));
		accumlatedscore.push(multiplier*value);
		console.log('Player' + currentplayer + ' threw ' + multiplier*value);
		$('#modal .modal-body').append("<div class='throw'>" + multiplier + '*' + value + '</div>');
		$('#modal').modal('hide');
		if((accumlatedscore.sum() + 1 >= (lastrest = $('#player' + currentplayer).children('.round').last().html()))){
			if (accumlatedscore.sum() == lastrest && multiplier == 2){
				//Utgang
				var score = accumlatedscore.sum();
				alert('Spelare' + currentplayer + ' vinner!');
				//Send the score to backend here, or should it be done after each round?
			}
			else{
				//Tjock
				var score = 0;
			}
			setscore(score);
		}
		else if (accumlatedscore.length == 3){
			var score = accumlatedscore.sum();
			setscore(score);
		}
		multiplier = 1;
	});

	$('#modal').modal({show: false, backdrop: false});
});

var setscore = function(score){
	setTimeout(function(){
		var player = $('#player' + currentplayer);
		var latestscore = parseInt(player.children('.round').last().html());
		console.log(latestscore);
		player.append("<div class='round'>" + (latestscore - score) + "</div>");
		player.removeClass('current');
		currentplayer = (currentplayer + 1) % 2;
		$('#player' + currentplayer).addClass('current');

		/* Reset score */
		$('#modal .modal-body').html('');
		accumlatedscore = [];
		//Send the score to backend here?
	}, 3000);
}
