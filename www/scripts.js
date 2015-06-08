var MAX = 20;
var MIN = 1;
var SIZE = "10px";
var INF = 10000;

var API_prefix = "api/http_accessible/";
var req_new_player = "join_game/";
var json_get_table = "get_field/";
var json_get_state = "who_won/";
var json_make_move = "try_make_turn/";
var json_who_plays = "who_plays/";

var COLORS = ["red","green","blue","yellow","black", "purple"];
var NUM;
var State=1;

function login(new_pl_name)
{
	$.ajax({
		url: API_prefix+req_new_player+new_pl_name,
		dataType: "json",
		async: "false"
		}).done(function(data){
		//alert(data);
		if (data.status == "ok")
			{	
				// alert("Welcome");
				$.ajax({
					url: API_prefix + json_who_plays,
					dataType: "json",
					async: "false"
					}).done(function(players)
						{
							NUM = players.length;
							//alert(NUM);
							alert("Welcome, " + $("#player_name").val());
							/*$("#p_name").html("Your name and color is: <font color=" + COLORS[NUM] + ">"+
							$("#player_name").val()+" (your number:"+NUM+")"); */
							$("#p_name").html("Your name is: " + $("#player_name").val());
							$("#p_name").attr("NUM", NUM);
							var FONT_MENU = $("<font>");
							FONT_MENU.insertAfter($("#p_name"));
							$("#new_player").css("visibility","hidden");
							$("#player_name").css("visibility","hidden");
							$(".registered").css("visibility","visible");
						})
			}
			else 
				alert("User already exists");
			})
			redraw();
			update();
}

function redraw()
{
	$.ajax({
		url: API_prefix+json_get_table,
		dataType: "json",
		async:"false"
		}).done(function(data)
		{
			var table= $("table#play_board");
			table.empty();
			for (var i = MIN; i <= MAX; ++i) 
			{
				var new_str=$("<tr>");
				new_str.appendTo($(table));
				
				for (var j = MIN; j <= MAX; ++j)
				{
					var new_col=$("<td>");
					new_col.attr("id", (INF * i + j));
					// data not used ///
					new_col.attr("bgcolor","white");
					//new_col.text
					//new_col.attr("bordercolor", "red");
					new_col.attr({width:SIZE, height:SIZE});
					//new_col.attr("onclick", "MOVE()");
					new_col.attr("onclick", "move(" + (INF * i + j) + ")")
					new_col.appendTo($(new_str));
					//$("#"+String(Number(MAX*(i-1)+j))).onclick(function(){move()});
				}
			}
			for (var i = 0; i < data.length; ++i) {
				id = data[i].x * INF + data[i].y;
				$("#" + id).text(data[i].user.substring(0,3));
			}
			
			
			setTimeout(function(){redraw(); update();}, 5000);
		})
		
};


function update(){
		$.ajax({
			url: API_prefix + json_get_state,
			dataType: "json",
			async:"false"
			}).done(function(data){
			if (data.status == "winner")
				alert("Winner: " + data.user);
			if (data.status == "next") 
				$("#State").text("Turn player number: " + data.user);
			if (data.status == "no_users")
				$("#State").text("There is no users");
		})
}


function move(id)
{
	//alert(id);
	var _id = Number(id);
	
	var line = Math.floor(_id / INF);
	// alert(_id);
	var col =  _id % INF;
	//alert(line);
	//alert(col);
	alert("col = " + String(col) + " line = " + String(line));
	
	// AJAX!!!!!
	$.ajax({
		url: API_prefix+json_make_move + line + "/" + col + "/" + $("#player_name").val(),
		dataType: "json",
		async:"false"
		}).done(function(data)
		{	
			if (data.status == "zanyato") {
				alert("Zanyato");
			}
			if (data.status == "not_your_turn") {
				alert("Not your turn");
			}
			if (data.status == "game_over") {
				alert("Game over");
			}
			if (data.status == "ok") {
				redraw();
			}
		})
}


$(document).ready(function(){
	$(".registered").css("visibility","hidden");
	$("#new_player").click(function(){login($("#player_name").val())});
})
	
	

