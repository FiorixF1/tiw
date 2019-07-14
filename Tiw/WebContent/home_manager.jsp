<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="beans.User"%>
<%@ page import="beans.Campaign"%>
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

	<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; width=device-width;">
<link rel="stylesheet" type="text/css" href="style_table_campagne.css">

<!-- ----------------------------MOSTRA FORM CREA CAMPAGNA--------------------------------------------- -->

<script type="text/javascript">
function switchDiv() {
	var firstDiv = document.getElementById("campaign_list");
	var secondDiv = document.getElementById("create_campaign_container");
	
	if (firstDiv.style.display === 'none') {
        firstDiv.style.display = 'block';
        secondDiv.style.display = 'none';
    } else {
    	firstDiv.style.display = 'none';
        secondDiv.style.display = 'block';
    }
}
</script>

<!-- ----------------------------MOSTRA FORM CREA CAMPAGNA--------------------------------------------- -->

</head>
<body>


<div style="width: 100%; height: 0px; position: relative;">
	<form action="Logout" method="get">
		<button type="submit" class="button button-block logout" >Logout</button>
	</form>
</div>

	
	<!-- ----------------------------LISTA CAMPAGNE--------------------------------------------- -->
	<br />
	<br />
	
	<div id="campaign_list" style="display:block;">
	<div class="home_container">
		<%
		User user = (User)session.getAttribute("user");
		%>	<h1><%= user.getFirstName() %> <%= user.getLastName() %> (Manager)</h1><br />

			<%
				List<Campaign> campaignBeans = (List<Campaign>) session.getAttribute("campaign_beans");
				if (campaignBeans.isEmpty()) {
			%>
			<h2>Non hai nessuna campagna!</h2>
			<%
				} else {
			%>
			<table class="table-fill" style="height: auto;">

				<tr class="campaign-create">
					<th class="text-center">Name Of Campaign</th>
					<th class="text-center">Users for Image Selection</th>
					<th class="text-center">Least Positive Ratings</th>
					<th class="text-center">Users for Image Annotation</th>
					<th class="text-center">Line Pixels</th>
					<th class="text-center">Statistics</th>
					<th class="text-center">Active</th>
				</tr>

				<tbody class="table-hover">
					<%
						for (Campaign bean : campaignBeans) {
					%>
					<tr class="campaign-create">
						<td class="table-create-campaign"><%=bean.getName()%></td>
						<td class="table-create-campaign"><%=bean.getUsersForImageSelection()%></td>
						<td class="table-create-campaign"><%=bean.getLeastPositiveRatings()%></td>
						<td class="table-create-campaign"><%=bean.getUsersForImageAnnotation()%></td>
						<td class="table-create-campaign"><%=bean.getLinePixels()%></td>
						<td class="text-center table-create-campaign">
							<form action="ManagerStatistics" method="post">
								<button class="button button-block" type="submit"
									style="font-size: 1rem; padding: 7px 0; height: 30px; width: 200px;">View Stats</button>
								<input type="hidden" name="campaign" value=<%=bean.getName()%> /> <br />
							</form>
						</td>
						<td class="table-create-campaign" id="<%=bean.getName()%>">
						<% if (bean.isActive() == 1) { %>
							Active
						<% } else { %>
								<button class="button button-block" onclick="activateCampaign('<%=bean.getName()%>')"
								style="font-size: 1rem; padding: 7px 0; height: 30px; width: 200px;">Activate</button>
								
								<br />

								<button class="button button-block button-cancel" onclick="deleteCampaign('<%=bean.getName()%>')"
								style="font-size: 1rem; padding: 7px 0; height: 30px; width: 200px;">Delete</button>
						<% } %>
						</td>
					</tr>
					<% } %>
				</tbody>
			</table>
			<% } %>
	<br />
	<br />
		<button class="button button-block" style="width: 200px;font-size: 1rem;margin-right: 0px;margin-left: 82.35%;/*1100px;*/"onclick="switchDiv()">Create campaign</button> <br />
	</div>
	</div>

	<!-- ----------------------------LISTA CAMPAGNE--------------------------------------------- -->
	
	<!-- ----------------------------CREA CAMPAGNA--------------------------------------------- -->
	
	<div id="create_campaign_container" style="display:none;">
	
		<% List<String> worker_usernames = (List<String>)session.getAttribute("worker_usernames"); %>
	
		<div class="form">
		
			<div class="tab-content">
				<div id="create_campaign">
					<h1>Create New Campaign</h1>
					<form id="myForm" method="post" enctype="multipart/form-data">
						<div class="field-wrap">
							<label> Name of Campaign</label>
							<input type="text" name="name" required autocomplete="off" />
						</div>

						<div class="field-wrap">
							<label> Users For Image Selection</label>
							<input type="number" min="1" name="users_for_image_selection" required autocomplete="off" />
						</div>

						<div class="field-wrap">
							<label> Least Positive Ratings</label>
							<input type="number" min="1" name="least_positive_ratings" required autocomplete="off" />
						</div>

						<div class="field-wrap">
							<label> Users For Image Annotation</label>
							<input type="number" min="1" name="users_for_image_annotation" required autocomplete="off" />
						</div>
					
						<div class="field-wrap">
							<label> Line Pixels</label>
							<input type="number" min="1" max="10" name="line_pixels" required autocomplete="off" />
						</div>
					
						<div class="field-wrap">
						<fieldset>
							<label> Upload Images </label> <br /> <br />
							<input type="file" id="upload_images" name="upload_images" multiple="multiple" required autocomplete="off" />
						</fieldset>
						</div>

						<div>
						<table class="tab-content" style=" display:block; text-align:center; overflow-y: scroll; height:200px;"> 
							<tr style="align:center; width:100%;">
								<td width="33%">User For Selection</td>
								<td></td>
								<td width="33%">User For Annotation</td>
							</tr>
							<% for (String username : worker_usernames) { %>
							<tr align="center">
								<td width="33%">
									<div class="group">
										<input type="checkbox" class="check" id="check" name="workers_selection" value="<%= username %>">
									</div>
								</td>
								<td width="33%">
									<%= username %>
								</td>
								<td width="33%">
									<div class="group">
										<input type="checkbox" class="check" id="check" name="workers_annotation" value="<%= username %>">
									</div>
								</td>
							</tr>
							<% } %>
						</table>
						</div>			
						<br />
						<br />
	
						<table align="center" style="display: table; border-left-width: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; padding-left: 0px; padding-right: 0px;">	
							<tr>
								<td width="100%" style="padding-right: 0px;">
									<button type="submit" class="button button-block"> Create</button>
								</td>
							</tr>
							<tr>
								<td>
									<h1 id="error"></h1>
								</td>
							</tr>
						</table>
					</form>
						<div>
							<button onclick="switchDiv()" class="button button-block home">Home</button>
						</div>
				
				</div>

				<div></div> <!--  NON TOGLIERE QUESTA COPPIA DI DIV, ALTRIMENTI SI SPACCA LA GRAFICA INSPIEGABILMENTE -->

			</div>
			<!-- tab-content -->

		</div>
		<!-- /form -->
		<script
			src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

		<script src="index.js"></script>
	
	</div>
	
	<!-- ----------------------------CREA CAMPAGNA--------------------------------------------- -->

<script type="text/javascript">
function activateCampaign(campaignName) {
	$.post("ActivateCampaign", {
		campaign: campaignName
		},
		function (data, status) {
			$("#" + campaignName).html("Active");	
	});
}
	
function deleteCampaign(campaignName) {
	$.post("DeleteCampaign", {
		campaign: campaignName
		},
		function (data, status) {
			$("#" + campaignName).parent().remove();	
	});
}
	
$(document).ready(function () {
	// codice JavaScript per la creazione della campagna via AJAX
	// questa funzione permette di serializzare le immagini insieme agli altri parametri
	(function($) {
		$.fn.serializeFiles = function() {
		    var obj = $(this);
		    var formData = new FormData();
		    $.each($(obj).find("input[type='file']"), function(i, tag) {
		        $.each($(tag)[0].files, function(i, file) {
		            formData.append(tag.name, file);
		        });
		    });
		    var params = $(obj).serializeArray();
		    $.each(params, function(i, val) {
		        formData.append(val.name, val.value);
		    });
		    return formData;
		};
	})(jQuery);
	
	$('#myForm').on('submit', function(e) {
		e.preventDefault();
		$("#error").html("Loading...");
		
		$.ajax({
			url: "CreateCampaign",
			data: $("#myForm").serializeFiles(),
			processData: false,
			contentType: false,
			type: "POST",
			success: function (data, status) {
				if (data == "200") {
					location.reload(true);
				} else {
					$("#error").html(data);
				}
			}
		});
	});
});
		
</script>

</body>
</html>
