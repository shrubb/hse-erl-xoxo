var MAX = 40;
var MIN = 1;
var SIZE="20px";
var req_new_player="";
var json_get_table="";
var json_get_state="";
var json_make_move="";
var COLORS = ["red","green","blue","yellow","black", "purple"];
var NUM;
var State=1;

function login(new_pl_name)
{
	$.ajax({
		url:req_new_player+new_pl_name,
		dataType: "json",
		async:"false"
		}).done(function(data){
		if (data.Exit_code=="0")
			{
				NUM = data.num;
				alert("Welcome");
				$("#p_name").html("Your name and color is: <font color=" + COLORS[NUM] + ">"+$("#player_name").val()+" (your number:"+NUM+")");
				$("#p_name").attr("NUM",NUM);
				var FONT_MENU=$("<font>");
				FONT_MENU.insertAfter($("#p_name"));
				$("#new_player").css("visibility","hidden");
				$("#player_name").css("visibility","hidden");
				$(".registered").css("visibility","visible");
			}
			else 
				alert("Already exist");	
			})
			redraw();
			update();
}

function redraw()
{
	$.ajax({
		url:json_get_table,
		dataType: "json",
		async:"false"
		}).done(function(data)
		{
			var table= $("table#play_board");
			for (var i=MIN; i<=MAX; i++) 
			{
				var new_str=$("<tr>");
				new_str.appendTo($(table));
				for (var j = MIN; j <= MAX; j++)
				{
					var new_col=$("<td>");
					new_col.attr("id", (INF*(i-1)+j));
					// data not used ///
					new_col.attr("bgcolor","white");
					//new_col.attr("bordercolor", "red");
					new_col.attr({width:SIZE, height:SIZE});
					//new_col.attr("onclick", "MOVE()");
					new_col.attr("onclick", "move(" + (INF*(i-1)+j) + ")")
					new_col.appendTo($(new_str));
					//$("#"+String(Number(MAX*(i-1)+j))).onclick(function(){move()});
				}
			}
			
			setTimeout(function(){redraw(); update();}, 5000);
		})
		
};


function update(){
		$.ajax({
			url:json_get_state,
			dataType: "json",
			async:"false"
			}).done(function(data){
			if (data.State == 0)
				alert("Winner :"+data.Winner);
			State = data.State;
			$("#State").text("Turn player number: "+State);
		})
}


function move(id)
{
	//alert(id);
	var _id = id;
	
	var l = Math.floor(Number(id)/INF);
	alert(id);
	//var с = Number(id) - INF*l;
	alert(l);
	//alert(c);
	//alert("col = " + String(col) + " line = " + String(line));
	
	// AJAX!!!!!
	/*$.ajax({
		url:json_get_table,
		dataType: "json",
		async:"false"
		}).done(function(data)
		{	
			
		})*/
}


$(document).ready(function(){
	$(".registered").css("visibility","hidden");
	$("#new_player").click(function(){login($("#player_name").val())});
})
	
	

