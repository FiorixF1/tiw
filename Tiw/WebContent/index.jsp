<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="beans.User" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>TIW PROJECT</title>
<link
	href='http://fonts.googleapis.com/css?family=Titillium+Web:400,300,600'
	rel='stylesheet' type='text/css'>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">
<link rel="stylesheet" href="style.css" />
</head>
<body>

	<% // se non c'è una sessione valida chiedi signin o login, altrimenti vai nella home
	if (session == null || session.getAttribute("user") == null) { %>

	<div class="form">
		<div>
			<h1>
				Benvenuto in TIW Project!
			</h1>
		</div>

		<ul class="tab-group">
			<li class="tab active"><a href="#signup">Sign Up</a></li>
			<li class="tab"><a href="#login">Log In</a></li>
		</ul>

		<!-- SIGN UP -->

		<div class="tab-content">
			<div id="signup">
				<h1>Sign Up!</h1>
				<form id="signup_form" method="post">
					<div class="top-row">
						<div class="field-wrap">
							<label> First Name<span class="req">*</span>
							</label> <input type="text" name="first_name" autofocus required autocomplete="off" />
						</div>

						<div class="field-wrap">
							<label> Last Name<span class="req">*</span>
							</label> <input type="text" name="last_name" required autocomplete="off" />
						</div>
					</div>

					<div class="field-wrap">
						<label> Email Address<span class="req">*</span>
						</label> <input type="email" name="email" required autocomplete="off" />
					</div>

					<div class="field-wrap">
						<label> Username<span class="req">*</span>
						</label> <input type="text" name="username" id="username" required autocomplete="off" />
					</div>

					<div class="field-wrap">
						<label> Set A Password<span class="req">*</span>
						</label> <input type="password" name="password" id="password"
							required autocomplete="off" />
					</div>

					<div class="field-wrap">
						<label> Confirm Password<span class="req">*</span>
						</label> <input type="password" name="confirm_password"
							id="confirm_password" required autocomplete="off" />
					</div>

					<div class="field-wrap">
						<fieldset>
							<label>Role<span class="req">*</span></label> <br> <br>

							<select name="role" id="role">
								<option value="none" id="none">-</option>
								<option value="worker">Lavoratore</option>
								<option value="manager">Gestore</option>
							</select>
						</fieldset>
					</div>

					<button type="submit" class="button button-block"> Get Started</button>
					
					<div>
						<h1 id="signup_error"></h1>
					</div>
				</form>

			</div>


			<!-- LOG IN -->


			<div id="login">
				<h1>Welcome Back!</h1>

				<form id="login_form" method="post">

					<div class="field-wrap">
						<label>Username o Email<span class="req">*</span>
						</label> <input type="text" name="username" required autofocus
							autocomplete="off" />
					</div>

					<div class="field-wrap">
						<label>Password<span class="req">*</span>
						</label> <input type="password" name="password" required
							autocomplete="off" />
					</div>

					<p class="forgot">
						<a href="#">Did you forget your credential?</a>
					</p>

					<button class="button button-block">Log In</button>
					
					<div>
						<h1 id="login_error"></h1>
					</div>
				</form>

			</div>

		</div>
		<!-- tab-content -->

	</div>
	<!-- /form -->
	<script
		src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>

	<script src="index.js"></script>


	<% } else {
		User user = (User)session.getAttribute("user");
		
		if (user.getRole().equals("worker")) {
				response.sendRedirect("HomeWorker");
		} else if (user.getRole().equals("manager")) {
				response.sendRedirect("HomeManager");
		}
	} %>

<!-- ---------------------------CONTROLLO PASSWORD---------------------------------------------- -->

<script type="text/javascript">
function validatePassword() {
  var password = document.getElementById("password").value;
  var confirm_password = document.getElementById("confirm_password").value;
  
  if (password == confirm_password) {
    return warningRoleNone();
  } else {
	$("#signup_error").html("Le password non coincidono!");
    return false;
  }
}
</script>

<!-- -----------------------------CONTROLLO PASSWORD---------------------------------------- -->

<!-- ----------------------------WARNING NESSUN RUOLO--------------------------------------------- -->

<script type="text/javascript">
function warningRoleNone() {
  var role = document.getElementById("role").value;
  var none = document.getElementById("none").value;
  
  if (role != none) {
    return warningChiocciola();
  } else {
	$("#signup_error").html("Inserisci un ruolo!");
    return false;
  }
}
</script>

<!-- ------------------------------WARNING NESSUN RUOLO--------------------------------------- -->

<!-- ----------------------------WARNING @ NELL'USERNAME--------------------------------------------- -->

<script type="text/javascript">
function warningChiocciola() {
  var username = document.getElementById("username").value;
  var invalid_regexp = /.*@.*/
  
  if (!invalid_regexp.test(username)) {
    return true;
  } else {
	$("#signup_error").html("Non puoi utilizzare il carattere @ nello username!");
    return false;
  }
}
</script>

<!-- ------------------------------WARNING @ NELL'USERNAME--------------------------------------- -->

<!-- ---------------------------------SCRIPT SIGN UP--------------------------------- -->
<script type="text/javascript">

action="Signup"

$('#signup_form').on('submit', function(e) {
	e.preventDefault();
	
	var CAN_CONTINUE = validatePassword();
	if (CAN_CONTINUE) {
		$.post("Signup", $('#signup_form').serialize(), function (data, status) {
			if (data == "null") {
				location.reload(true);
			} else {
				$("#signup_error").html(data);
			}
		});
	}
});

$('#login_form').on('submit', function(e) {
	e.preventDefault();
	
	$.post("Login", $('#login_form').serialize(), function (data, status) {
		if (data == "200") {
			location.reload(true);
		} else {
			$("#login_error").html("Il nome utente o la password non sono corretti");
		}
	});
});
</script>
<!-- ---------------------------------SCRIPT SIGN UP--------------------------------- -->

</body>
</html>