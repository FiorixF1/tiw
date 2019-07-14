<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="beans.User"%>
<%@ page import="beans.WorkerCampaign"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HOME</title>
<link
	href='http://fonts.googleapis.com/css?family=Titillium+Web:400,300,600'
	rel='stylesheet' type='text/css'>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet" href="style.css" />

	<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, width=device-width">
	<link rel="stylesheet" type="text/css" href="style_table_campagne.css">
</head>
<body>

<div style="width: 100%; height: 0px; position: relative;">
	<form action="Logout" method="get">
		<button type="submit" class="button button-block logout" >Logout</button>
	</form>
</div>

	<br />
	<br />
	<div class="home_container">
	<%
	User user = (User)session.getAttribute("user");
	%> <h1><%= user.getFirstName() %> <%= user.getLastName() %> (Worker) </h1>
	
	<%  
	List<WorkerCampaign> workerCampaignBeans = (List<WorkerCampaign>)session.getAttribute("worker_campaign_beans");
	if (workerCampaignBeans.isEmpty()) { %>
		<h2>Non sei abilitato per nessuna campagna!</h2>
	<% } else { %>
		<table class="table-fill" style="height: auto;">
			<tr class="campaign">
				<th class="text-center">Name Of Campaign</th>
				<th class="text-center">Manager</th>
				<th class="text-center">Enabled Tasks</th>
				<th class="text-center">Statistics</th>
			</tr>
			<%
				for (WorkerCampaign bean : workerCampaignBeans) {
			%>
			<tbody class="table-hover">
			<tr class="campaign-create">
				<td class="text-center table-create-campaign"><%=bean.getCampaign()%></td>
				<td class="text-center table-create-campaign"><%=bean.getManager()%></td>
				<td class="text-center table-create-campaign">
					<%
						if (bean.getSelectionTask()) {
					%>

					<form action="SelectionTask" method="post">
						<button class="button button-block" type="submit"
							style="font-size: 1rem; padding: 7px 0; height: 30px; width: 200px;">Selection
							Task</button>
						<input type="hidden" name="campaign"
							value=<%= bean.getCampaign() %> /> <br />
					</form> <% }
    					if (bean.getAnnotationTask()) { %>

					<form action="AnnotationTask" method="post">
						<button class="button button-block" type="submit"
							style="font-size: 1rem; padding: 7px 0; height: 30px; width: 200px;">Annotation
							Task</button>
						<input type="hidden" name="campaign"
							value=<%= bean.getCampaign() %> />
					</form> <% } %>
				</td>
				<td class="text-center table-create-campaign">
					<form action="WorkerStatistics" method="post">
						<button class="button button-block" type="submit"
							style="font-size: 1rem; padding: 7px 0; height: 30px; width: 200px;">View Stats</button>
						<input type="hidden" name="campaign"
							value=<%= bean.getCampaign() %> /> <br />
					</form>
				</td>
			</tr>
			</tbody>
			<% } %>

		</table>
		<% } %>
    	</div>
</body>
</html>