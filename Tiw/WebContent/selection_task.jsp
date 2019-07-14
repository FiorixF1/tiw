<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="beans.User"%>
<%@ page import="java.io.File"%>
<!DOCTYPE html">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Selection Task</title>
<link
	href='http://fonts.googleapis.com/css?family=Titillium+Web:400,300,600'
	rel='stylesheet' type='text/css'>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet" href="style.css" />
</head>
<body>

	<%
		User user = (User) request.getSession().getAttribute("user");
		String imageToShow = (String) request.getAttribute("image_to_show");
		String campaign = request.getParameter("campaign");
		
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
	<h1 style="margin-bottom: 20px;">Selection Task</h1>

		<div class="tab-content">
			<% if (imageToShow != null) { %>
					<img src="image/<%=campaign%><%=File.separator%><%=imageName%>"
						style="width: 100%;" />
					<br />
					<br />
					<br />
					<h1>Is it a Mountain?</h1>
					<br />

					<table style="border-left-width: 0px; border-top-width:0px;height: auto; border-right-width: 0px; border-bottom-width: 0px; padding-left: 0px; padding-right: 0px;">
						<tr>
							<td width="50%" style="padding-left: 0px;">
							
							<form action="Rating" method="post">
								<button class="button button-block button-cancel" type="submit">No</button>
								<input type="hidden" name="rating" value="no" />
								<input type="hidden" name="image_to_show" value="<%= imageToShow%>" />
								<input type="hidden" name="campaign" value="<%= campaign%>" />
							</form>
							</td>
							
							<td></td>
							<td width="50%" style="padding-right: 0px;">
								<form action="Rating" method="post">
								<button class="button button-block" type="submit">Yes</button>
								<input type="hidden" name="rating" value="yes" />
								<input type="hidden" name="image_to_show" value="<%= imageToShow%>" />
								<input type="hidden" name="campaign" value="<%= campaign%>" />
							</form>
							</td>
						</tr>
					</table>
			<% } else { %>
				<h2>There are no images left for this campaign.</h2>
			<% } %>

		<div></div>	<!--  NON TOGLIERE QUESTA COPPIA DI DIV, ALTRIMENTI SI SPACCA LA GRAFICA INSPIEGABILMENTE -->
			
		</div>
		<!-- tab-content -->

	</div>
	<!-- /form -->
	<script
		src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

	<script src="index.js"></script>

</body>
</html>