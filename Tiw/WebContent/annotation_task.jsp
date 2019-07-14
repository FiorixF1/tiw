<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="beans.User"%>
<%@ page import="java.io.File"%>
<!DOCTYPE html">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Annotation Task</title>
<link
	href='http://fonts.googleapis.com/css?family=Titillium+Web:400,300,600'
	rel='stylesheet' type='text/css'>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet" href="style.css" />

</head>
<body>

	<%
		User user = (User)request.getSession().getAttribute("user");
		String imageToShow = (String)request.getAttribute("image_to_show");
		String campaign = request.getParameter("campaign");
		int linePixels = (int)request.getAttribute("line_pixels");
		
		// imageToShow contiene il path per intero, a noi interessa solo il nome dell'immagine
		String imageName = null;
		if (imageToShow != null) {
			int lastSeparatorIndex = imageToShow.lastIndexOf(File.separator);
			imageName = imageToShow.substring(lastSeparatorIndex+1);
		}
	%>

	<div style="width: 100%; height: 0px; position: relative;">
		<a href="/Tiw/HomeWorker">
			<button class="button button-block home">Home</button>
		</a>
	</div>
	
	<div style="width: 0px; height: 0px;">
		<form class="button button-block" action="Logout" method="get">
			<button type="submit" class="button button-block logout">Logout</button>
		</form>
	</div>
	
<br />
<br />

	<div class="form" style="height: relative; width: 98%; padding-top: 30px; padding-bottom: 50px;" >
	<h1 style="margin-bottom: 20px;">Annotation Task</h1>

		<div class="tab-content">
			<% if (imageToShow != null) { %>
				<canvas id="annotation_canvas"></canvas>
				<img id="image_source" style="width: 100%"/>
				
				<br />
				<br />
				<br />
				<h1>Draw the skyline of the mountains in the picture</h1>
				<h2> Press "Submit" to confirm, "Clear" to restart</h2>
				<br />

				<table style="border-left-width: 0px; border-top-width:0px;height: auto; border-right-width: 0px; border-bottom-width: 0px; padding-left: 0px; padding-right: 0px;">
					<tr>
						<td width="50%" style="padding-left: 0px;">
							<button class="button button-block button-cancel" onclick="resetCanvas()">Clear</button>
						</td>
							
						<td></td>
							
						<td width="50%" style="padding-right: 0px;">
							<button class="button button-block" onclick="sendAnnotation()">Submit</button>
						</td>
					</tr>
				</table>
				
			<% } else { %>
				<h2>There are no images to annotate. Try again later.</h2>
			<% } %>
				
		<div></div>	<!--  NON TOGLIERE QUESTA COPPIA DI DIV, ALTRIMENTI SI SPACCA LA GRAFICA INSPIEGABILMENTE -->
			
		</div>
		<!-- tab-content -->

	</div>
	<!-- /form -->

	<script
		src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

	<script src="index.js"></script>
	
<!-- ----------------------------GESTORE CANVAS--------------------------------------------- -->

<script type="text/javascript">

var canvas;			// riferimento all'elemento <canvas>
var context;		// contesto del canvas
var imageSource;	// riferimento all'elemento <img> che contiene l'immagine

var lastIndex = -1;				// indice dell'ultimo elemento negli array
var clickX = new Array();		// array di coordinate X
var clickY = new Array();		// array di coordinate Y
var clickDrag = new Array();	// array per segnalare le diverse componenti della linea
var paint = false;				// flag che indica se stiamo disegnando

$(document).ready(function () {
	canvas = document.getElementById("annotation_canvas");
	context = canvas.getContext("2d");
	imageSource = document.getElementById("image_source");

	// funzione da eseguire quando l'immagine è stata caricata
	imageSource.onload = function () {
		// adatta le dimensioni del canvas a quelle del tag <img>
		canvas.width = imageSource.width;
		canvas.height = imageSource.height;
		
		// inserisci l'immagine dentro il canvas
		context.drawImage(imageSource, 0, 0, imageSource.naturalWidth, imageSource.naturalHeight,  // source rectangle
	  		  						   0, 0, canvas.width, canvas.height);  // destination rectangle
	  		  						   
		// nascondi il tag <img>
		imageSource.style.display = 'none';
	};
	// per qualche assurdo motivo, File.separator qui dà 404 su Windows, mentre funziona con lo slash normale
	imageSource.src = "image/<%=campaign%>/<%=imageName%>";

	function addClick(x, y, dragging) {
		++lastIndex;
		clickX.push(x);
		clickY.push(y);
		clickDrag.push(dragging);
	}

	function draw() {
		context.strokeStyle = "#df4b26";
		context.lineJoin = "round";
		context.lineWidth = <%= linePixels %>;  // parametro passato dalla campagna
		
		context.beginPath();
		if (clickDrag[lastIndex] && lastIndex) {
		    context.moveTo(clickX[lastIndex-1], clickY[lastIndex-1]);
		} else {
			context.moveTo(clickX[lastIndex]-1, clickY[lastIndex]);
		}
		context.lineTo(clickX[lastIndex], clickY[lastIndex]);
		context.stroke();
		context.closePath();
	}

	$('#annotation_canvas').mousedown(function(e) {
		var mouseX = e.clientX - canvas.getBoundingClientRect().left;
		var mouseY = e.clientY - canvas.getBoundingClientRect().top;
			
	  	paint = true;
	  	addClick(mouseX, mouseY, false);
		draw();
	});
	
	$('#annotation_canvas').mousemove(function(e) {
		if (paint) {
			var mouseX = e.clientX - canvas.getBoundingClientRect().left;
			var mouseY = e.clientY - canvas.getBoundingClientRect().top;
		  
			addClick(mouseX, mouseY, true);
		    draw();
		}
	});

	$('#annotation_canvas').mouseup(function(e) {
		paint = false;
	});

	$('#annotation_canvas').mouseleave(function(e) {
		paint = false;
	});
});

function resetCanvas() {
	// cancella il contenuto del canvas
	context.clearRect(0, 0, canvas.width, canvas.height);
	
	// reinserisci l'immagine
	context.drawImage(imageSource, 0, 0, imageSource.naturalWidth, imageSource.naturalHeight,  // source rectangle
  		  						   0, 0, canvas.width, canvas.height);  // destination rectangle

	// resetta le variabili
	lastIndex = -1;
	clickX = new Array();
	clickY = new Array();
	clickDrag = new Array();
	paint = false;
}

function sendAnnotation() {
	if (lastIndex == -1) {
		alert("You did not draw the skyline!");
		return;
	}
	
	var annotation = {
			worker: "<%=user.getUsername()%>",
			width: canvas.width,
			height: canvas.height,
			x: clickX,
			y: clickY,
			drag: clickDrag
	};
	var jsonAnnotation = JSON.stringify(annotation);
	
	$.post("Annotation", {
		json_annotation: jsonAnnotation,
		campaign: "<%=campaign%>",
		image_name: "<%=imageName%>"
	}, function (data, status) {
		document.open("text/html", "replace");
		document.write(data);
		document.close();
	});
}

</script>

<!-- ----------------------------GESTORE CANVAS--------------------------------------------- -->

</body>
</html>