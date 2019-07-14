package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.User;
import start.DatabaseManager;

@WebServlet("/Signup")
public class Signup extends HttpServlet {
	private static final long serialVersionUID = 3040804169652781572L;

	public Signup() {
        super();
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String firstName = request.getParameter("first_name");
		String lastName = request.getParameter("last_name");
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String role = request.getParameter("role");
		
		User user = new User();
		user.setFirstName(firstName);
		user.setLastName(lastName);
		user.setUsername(username);
		user.setEMail(email);
		user.setPassword(password);
		user.setRole(role);
		
		String error = null;
		if (!isRoleInvalid(role) && !isUsernameInvalid(username)) {   // isRoleInvalid = esistenza del ruolo, isUsernameInvalid = presenza della chiocciola
		    error = DatabaseManager.executeUpdate("insert into user values (?, ?, ?, ?, ?, ?);",
				firstName, lastName, username, email, password, role);
		}
		
		// se la stringa error è vuota è andato tutto a buon fine, se no qualcosa è andato storto nel database
		// oppure alcuni parametri non sono corretti
		response.getWriter().print(error);
		
		if (error == null) {
			request.getSession().setAttribute("user", user);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	protected boolean isRoleInvalid(String role) {
		return !role.equals("manager") && !role.equals("worker");
	}
	
	protected boolean isUsernameInvalid(String username) {
		return username.contains("@");
	}
}