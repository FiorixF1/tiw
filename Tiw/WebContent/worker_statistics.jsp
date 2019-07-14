<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="beans.User"%>
<!DOCTYPE html">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Worker Statistics</title>
<link
	href='http://fonts.googleapis.com/css?family=Titillium+Web:400,300,600'
	rel='stylesheet' type='text/css'>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet" href="style.css" />
<link rel="stylesheet" type="text/css" href="style_table_campagne.css">
</head>
<body>

	<%
		User user = (User)request.getSession().getAttribute("user");
		String campaign = request.getParameter("campaign");
		
		Long numOfAcceptedImages = (Long)request.getAttribute("num_of_accepted_images");
		Long numOfDiscardedImages = (Long)request.getAttribute("num_of_discarded_images");
		Long numOfAnnotatedImages = (Long)request.getAttribute("num_of_annotated_images");
		Long numOfImagesToSelect = (Long)request.getAttribute("num_of_images_to_select");
		Long numOfImagesToAnnotate = (Long)request.getAttribute("num_of_images_to_annotate");
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
	<div class="home_container">
		<h1>Statistiche campagna "<%= campaign %>"</h1>
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
			
			<% if (numOfImagesToSelect != null) { %>
				<tr class="campaign-create">
					<th class="text-center">Number of Images to Select</th>
					<td class="text-center"><%= numOfImagesToSelect %></td>
				</tr>
			<% } %>
			
			<% if (numOfImagesToAnnotate != null) { %>
				<tr class="campaign-create">
					<th class="text-center">Number of Images to Annotate</th>
					<td class="text-center"><%= numOfImagesToAnnotate %></td>
				</tr>
			<% } %>
			</tbody>
		</table>
    </div>

	<script
		src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

	<script src="index.js"></script>
	
</body>
</html>