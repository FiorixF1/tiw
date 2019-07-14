package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.User;
import start.DatabaseManager;

@WebServlet("/Rating")
public class Rating extends HttpServlet {
	private static final long serialVersionUID = -738877018948835440L;

	public Rating() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User worker = (User)request.getSession().getAttribute("user");
		if (worker == null || worker.getRole().equals("manager")) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);  // 403
			return;
		}
		
		String imageToShow = request.getParameter("image_to_show");
		String rating = request.getParameter("rating");
		
		boolean ratingBool;
		if (rating.equals("yes")) {
			ratingBool = true;
		} else if (rating.equals("no")) {
			ratingBool = false;
		} else {
			return;
		}
		
		// Cancella il voto pendente dal database, dato che è stato ricevuto
		DatabaseManager.executeUpdate("delete from pending_rating where worker = ? and image = ?;", worker.getUsername(), imageToShow);
		// E inserisci il voto vero e proprio
		DatabaseManager.executeUpdate("insert into rating values (?, ?, ?);", worker.getUsername(), imageToShow, ratingBool);
		   
		request.getServletContext().getRequestDispatcher("/SelectionTask").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}