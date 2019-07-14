<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="beans.User"%>
<%@ page import="beans.Image"%>
<%@ page import="beans.Campaign"%>
<%@ page import="java.util.List"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.io.File"%>
<!DOCTYPE html">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Manager Statistics</title>
<link
	href='http://fonts.googleapis.com/css?family=Titillium+Web:400,300,600'
	rel='stylesheet' type='text/css'>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet" href="style.css" />
<link rel="stylesheet" type="text/css" href="style_table_campagne.css">

<!-- ----------------------------MOSTRA DIV IMMAGINI--------------------------------------------- -->

<script type="text/javascript">

// variabile booleana globale per gestire la stampa delle annotazioni
ANNOTATIONS_CREATED = false;

function showDiv(id) {
	var acceptedDiv = document.getElementById("accepted");
	var discardedDiv = document.getElementById("discarded");
	var annotatedDiv = document.getElementById("annotated");
	
	switch (id) {
		case "accepted":  // mostra immagini accettate
			if (acceptedDiv.style.display == 'block') {
				acceptedDiv.style.display = 'none';
			} else {
	        	acceptedDiv.style.display = 'block';
	        	discardedDiv.style.display = 'none';
	        	annotatedDiv.style.display = 'none';
			}
			break;
		case "discarded":  // mostra immagini rifiutate
	    	if (discardedDiv.style.display == 'block') {
				discardedDiv.style.display = 'none';
			} else {
	        	acceptedDiv.style.display = 'none';
	        	discardedDiv.style.display = 'block';
	        	annotatedDiv.style.display = 'none';
			}
			break;
		case "annotated":  // mostra immagini annotate
	    	if (annotatedDiv.style.display == 'block') {
				annotatedDiv.style.display = 'none';
			} else {
				// le annotazioni vengono create solo nel momento in cui l'utente le chiede la prima volta
				// questo perchÃ© crearle subito al caricamento mi ha fatto perdere ore senza successo 
				if (!ANNOTATIONS_CREATED) {
					annotatedDiv.style.display = 'block'
					createAnnotations();
					annotatedDiv.style.display = 'none'
					ANNOTATIONS_CREATED = true;
				}
				
        		acceptedDiv.style.display = 'none';
        		discardedDiv.style.display = 'none';
        		annotatedDiv.style.display = 'block';
			}
			break;
	}
}
</script>

<!-- ----------------------------MOSTRA DIV IMMAGINI--------------------------------------------- -->

<!-- -------------------------------MOSTRA CANVAS--------------------------------------------- -->

<script type="text/javascript">

function toggleCanvas(id) {
	var canvas_container = document.getElementById(id);
	
	if (canvas_container.style.display == 'none') {
		canvas_container.style.display = 'block';
	} else {
		canvas_container.style.display = 'none';
	}
}
</script>

<!-- -------------------------------MOSTRA CANVAS--------------------------------------------- -->

</head>
<body>

	<%
		User user = (User)request.getSession().getAttribute("user");
		Campaign campaign = (Campaign)request.getAttribute("campaign");
		
		Integer numOfAcceptedImages = (Integer)request.getAttribute("num_of_accepted_images");
		Integer numOfDiscardedImages = (Integer)request.getAttribute("num_of_discarded_images");
		Integer numOfAnnotatedImages = (Integer)request.getAttribute("num_of_annotated_images");
		BigDecimal averageNumOfAnnotationsForImage = (BigDecimal)request.getAttribute("average_num_of_annotations_for_image");
		
		List<Image> acceptedImages = (List<Image>)request.getAttribute("accepted_images");
		List<Image> discardedImages = (List<Image>)request.getAttribute("discarded_images");
	%>

	<div style="width: 100%; height: 0px; position: relative;">
		<a href="/Tiw/HomeManager">
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
	<div class="home_container">
		<h1>Statistiche campagna "<%= campaign.getName() %>"</h1>
		<table class="table-fill" style="height: auto;">
			<tbody class="table-hover">
			<% if (numOfAcceptedImages != null) { %>
				<tr class="campaign-create">
					<th class="text-center">Number of Accepted Images</th>
					<td class="text-center"><%= numOfAcceptedImages %></td>
				</tr>
			<% } %>
		
			<% if (numOfDiscardedImages != null) { %>
				<tr class="campaign-create">
					<th class="text-center">Number of Discarded Images</th>
					<td class="text-center"><%= numOfDiscardedImages %></td>
				</tr>
			<% } %>
			
			<% if (numOfAnnotatedImages != null) { %>
				<tr class="campaign-create">
					<th class="text-center">Number of Annotated Images</th>
					<td class="text-center"><%= numOfAnnotatedImages %></td>
				</tr>
			<% } %>
			
			<% if (averageNumOfAnnotationsForImage != null) { %>
				<tr class="campaign-create">
					<th class="text-center">Average Number of Annotations for Image</th>
					<td class="text-center"><%= averageNumOfAnnotationsForImage %></td>
				</tr>
			<% } %>
			</tbody>
		</table>
		
		<br />
		<br />
		
		<table style="border: none; height: auto">
			<tbody>
				<tr>
					<td style="padding: 20px"><button class="button button-block" onclick="showDiv('accepted')">Immagini accettate</button></td>
					<td style="padding: 20px"><button class="button button-block" onclick="showDiv('discarded')">Immagini rifiutate</button></td>
					<td style="padding: 20px"><button class="button button-block" onclick="showDiv('annotated')">Immagini annotate</button></td>
				</tr>
			</tbody>
		</table>
		
		<div id="accepted" style="display: none;">
			<br />
			<br />
			<h1>Immagini accettate</h1>
			<% if (acceptedImages != null) 
				for (Image img : acceptedImages) { %>
				<img src="image/<%= campaign.getName() %><%= File.separator %><%= img.getName() %>" style="width: 100%;" />
				<br />
				<br />
				<table style="border: none; height: auto">
					<tbody>
						<tr>
							<td style="padding: 20px"><h1>Voti positivi: <%= img.getPositiveRatings() %></h1></td>
							<td style="padding: 20px"><h1>Voti negativi: <%= img.getNegativeRatings() %></h1></td>
						</tr>
					</tbody>
				</table>
			<% } %>
		</div>
		
		<div id="discarded" style="display: none;">
			<br />
			<br />
			<h1>Immagini rifiutate</h1>
			<% if (discardedImages != null) 
				for (Image img : discardedImages) { %>
				<img src="image/<%= campaign.getName() %><%= File.separator %><%= img.getName() %>" style="width: 100%;" />
				<br />
				<br />
				<table style="border: none; height: auto">
					<tbody>
						<tr>
							<td style="padding: 20px"><h1>Voti positivi: <%= img.getPositiveRatings() %></h1></td>
							<td style="padding: 20px"><h1>Voti negativi: <%= img.getNegativeRatings() %></h1></td>
						</tr>
					</tbody>
				</table>
			<% } %>
		</div>
	
		<div id="annotated" style="display: none;">
			<br />
			<br />
			<h1>Annotazioni svolte</h1>
			<% if (acceptedImages != null)
				for (Image img : acceptedImages) {
					if (img.getAnnotations().size() > 0) { %>
					
						<img src="image/<%= campaign.getName() %><%= File.separator %><%= img.getName() %>" id="<%= img.getName() %>" style="width: 100%;" />
						<br />
						<br />
						<table style="border: none; height: auto">
							<tbody>
								<tr>
									<td style="padding: 20px"><br /><h1>Annotazioni: <%= img.getAnnotations().size() %></h1></td>
									<td style="padding: 20px"><button class="button button-block" onclick="toggleCanvas('<%= img.getName() %>_canvas_container')">Mostra</button></td>
								</tr>
							</tbody>
						</table>
				
						<div id="<%= img.getName() %>_canvas_container" style="display: none;">
							<br />
						<% for (String worker : img.getAnnotations().keySet() ) { %>
							<canvas id="<%= img.getName() %>_<%= worker %>.json"></canvas>
							<br />
							<br />
							<br />
							<br />
							<br />
							<br />
						<% } %>
						</div>
						<br />
				<% } %> 
			<% } %>
		</div>
	
    </div>

	<script
		src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

	<script src="index.js"></script>
	
<!-- ----------------------------DISEGNATORE DI ANNOTAZIONI--------------------------------------------- -->

<script type="text/javascript">

function createAnnotations() {
	// lista di tutte le annotazioni: la chiave è il nome dell'immagine, il valore è un array di JSON delle annotazioni
	// sono stati aggiunti dei valori a zero per motivi puramente sintattici
	var annotationList = {
	<% if (acceptedImages != null)
		for (Image img : acceptedImages) { %>
		"<%= img.getName() %>":	[	<% for (String annotation : img.getAnnotations().values() ) { %>
									<%= annotation %>,
									<% } %>
									0
		],
	<% } %>
		0: 0
	}
	
	// per ogni immagine costruisci i canvas contenenti le sue annotazioni
	for (imageName in annotationList) {
		if (imageName != 0) {
			var image = document.getElementById(imageName);
			buildCanvas(annotationList, imageName, image);
		}
	}
}

function buildCanvas(annotationList, imageName, image) {
	// per ogni annotazione dell'immagine processata, crea un canvas delle giuste dimensioni,
	// inserisci l'immagine e poi disegna l'annotazione
	for (i in annotationList[imageName]) {
		var annotation = annotationList[imageName][i];
		
		if (annotation != 0) {
			var canvas = document.getElementById(imageName + "_" + annotation["worker"] + ".json");
			var context = canvas.getContext("2d");
			
			canvas.width = image.width;
			canvas.height = image.height;
			context.drawImage(image, 0, 0, image.naturalWidth, image.naturalHeight,  // source rectangle
		  				             0, 0, canvas.width, canvas.height);  // destination rectangle
			
			drawAnnotation(canvas, annotation);
		}
	}
} 

// dato il canvas e il JSON dell'annotazione, questa funzione la disegna
// inoltre l'annotazione viene disegnata tenendo conto della possibile differenza di risoluzione
// tra lo schermo dell'utente attuale e quello usato dal lavoratore che ha tracciato l'annotazione
function drawAnnotation(canvas, annotation) {
	var annotationWidth = annotation["width"];
	var annotationHeight = annotation["height"];
	var clickX = annotation["x"];
	var clickY = annotation["y"];
	var clickDrag = annotation["drag"];
	
	var widthRatio = canvas.width/annotationWidth;
	var heightRatio = canvas.height/annotationHeight;
	
	context = canvas.getContext("2d");
	context.strokeStyle = "#df4b26";
	context.lineJoin = "round";
	context.lineWidth = <%= campaign.getLinePixels() %>;
	
	for (lastIndex in clickX) {
		context.beginPath();
		if (clickDrag[lastIndex] && lastIndex) {
			context.moveTo(clickX[lastIndex-1]*widthRatio, clickY[lastIndex-1]*heightRatio);
		} else {
			context.moveTo((clickX[lastIndex]-1)*widthRatio, clickY[lastIndex]*heightRatio);
		}
		context.lineTo(clickX[lastIndex]*widthRatio, clickY[lastIndex]*heightRatio);
		context.stroke();
		context.closePath();
	}
}

</script>

<!-- ----------------------------DISEGNATORE DI ANNOTAZIONI--------------------------------------------- -->
	
</body>
</html>