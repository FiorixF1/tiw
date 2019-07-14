package servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.User;
import start.DatabaseManager;

@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = -4143721484509460L;

	public Login() {
        super();
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		
		User user = null;
		
		// l'utente può loggarsi con username oppure e-mail: iniziamo a cercare la mail
		List<Map<String, Object>> result = DatabaseManager.executeQuery("select * from user where username = ? and password = ?;",
				username, password);
		
		if (result.size() == 1) {
			user = new User();
			Map<String, Object> tuple = result.get(0);
			user.setFirstName((String)tuple.get("first_name"));
			user.setLastName((String)tuple.get("last_name"));
			user.setUsername((String)tuple.get("username"));
			user.setEMail((String)tuple.get("email"));
			user.setPassword((String)tuple.get("password"));
			user.setRole((String)tuple.get("role"));
		}
		
		// se non abbiamo trovato niente, proviamo a cercare l'utente attraverso la mail
		if (user == null) {
			result = DatabaseManager.executeQuery("select * from user where email = ? and password = ?;",
					username, password);
			
			if (result.size() == 1) {
				user = new User();
				Map<String, Object> tuple = result.get(0);
				user.setFirstName((String)tuple.get("first_name"));
				user.setLastName((String)tuple.get("last_name"));
				user.setUsername((String)tuple.get("username"));
				user.setEMail((String)tuple.get("email"));
				user.setPassword((String)tuple.get("password"));
				user.setRole((String)tuple.get("role"));
			}
		}
		
		request.getSession().setAttribute("user", user);
		if (user != null) {
			response.getWriter().print("200");
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}