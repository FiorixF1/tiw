package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.User;
import start.DatabaseManager;

@WebServlet("/Logout")
public class Logout extends HttpServlet {
	private static final long serialVersionUID = -9166307201817868214L;

	public Logout() {
        super();
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		dropPendingRequests(request, response);
		request.getSession().invalidate();
		response.sendRedirect("/index.jsp");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	protected void dropPendingRequests(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Prima di fare il logout dell'utente, se si tratta di un lavoratore,
		// cancello tutte le richieste di immagini fatte che non hanno avuto riscontro (voto o annotazione)
		User user = (User)request.getSession().getAttribute("user");
		if (user == null || user.getRole().equals("manager")) {
			return;
		}
		
		DatabaseManager.executeUpdate("delete from pending_rating where worker = ?;", user.getUsername());
		DatabaseManager.executeUpdate("delete from pending_annotation where worker = ?;", user.getUsername());
	}
}