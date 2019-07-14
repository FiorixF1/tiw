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

@WebServlet("/SelectionTask")
public class SelectionTask extends HttpServlet {
	private static final long serialVersionUID = -5277792455830435396L;

	public SelectionTask() {
        super();
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User user = (User)request.getSession().getAttribute("user");
		if (user == null || user.getRole().equals("manager")) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);  // 403
			return;
		}
		
		String imageToShow = getNextImage(request, response);
		
		request.setAttribute("image_to_show", imageToShow);
		request.getServletContext().getRequestDispatcher("/selection_task.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	protected String getNextImage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User worker = (User)request.getSession().getAttribute("user");
		String campaign = request.getParameter("campaign");
		
		// Dobbiamo scegliere un'immagine per il task
		
		// Il primo passo dell'algoritmo prevede la cancellazione delle richieste scadute
		DatabaseManager.executeUpdate("delete from pending_rating where ? - timestamp >= ?;", System.currentTimeMillis()/1000, request.getSession().getMaxInactiveInterval());
		
		// Cancelliamo poi richieste precedenti dello stesso utente per le quali non si è ottenuto il voto
		DatabaseManager.executeUpdate("delete from pending_rating where worker = ?;", worker.getUsername());
		
		// Per scegliere la prossima immagine usiamo questi criteri:
		// - Deve appartenere alla campagna corrente
		// - Non deve essere già stata selezionata dall'utente corrente
		// - Deve avere rating_request_counter < users_for_image_selection
		// - Deve avere positive_ratings < least_positive_ratings
		// - Tra tutte le immagini che soddisfano questi criteri scegliamo quella col minor rating_request_counter
		// Se alla fine troviamo un'immagine, registriamo la richiesta nel database
		List<Map<String, Object>> nextImageQuery = DatabaseManager.executeQuery("select url from (image join image_statistics on url = image) join campaign on campaign = name " +
																				"where rating_request_counter < users_for_image_selection and positive_ratings < least_positive_ratings and campaign = ? and " +
																						"url not in (select image from rating where worker = ?)" +
																				"order by rating_request_counter asc;", campaign, worker.getUsername());
		if (!nextImageQuery.isEmpty()) {
			String nextImage = (String)nextImageQuery.get(0).get("url");
			DatabaseManager.executeUpdate("insert into pending_rating values (?, ?, ?)", nextImage, worker.getUsername(), System.currentTimeMillis()/1000);
			return nextImage;
		} else {
			return null;
		}
	}
}