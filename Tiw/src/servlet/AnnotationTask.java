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

@WebServlet("/AnnotationTask")
public class AnnotationTask extends HttpServlet {
	private static final long serialVersionUID = 119173337729516786L;

	public AnnotationTask() {
        super();
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User user = (User)request.getSession().getAttribute("user");
		if (user == null || user.getRole().equals("manager")) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);  // 403
			return;
		}
		
		String campaign = request.getParameter("campaign");
		
		String imageToShow = getNextImage(request, response);
		
		// Estraiamo il parametro line_pixels
		List<Map<String, Object>> linePixelsDb = DatabaseManager.executeQuery("select line_pixels from campaign where name = ? ;", campaign);
		int linePixels = (int)linePixelsDb.get(0).get("line_pixels");
		
		request.setAttribute("image_to_show", imageToShow);
		request.setAttribute("line_pixels", linePixels);
		request.getServletContext().getRequestDispatcher("/annotation_task.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	protected String getNextImage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User worker = (User)request.getSession().getAttribute("user");
		String campaign = request.getParameter("campaign");
		
		// Dobbiamo scegliere un'immagine per il task
		
		// Il primo passo dell'algoritmo prevede la cancellazione delle richieste scadute
		DatabaseManager.executeUpdate("delete from pending_annotation where ? - timestamp >= ?;", System.currentTimeMillis()/1000, request.getSession().getMaxInactiveInterval());
		
		// Cancelliamo poi richieste precedenti dello stesso utente per le quali non si è ottenuta l'annotazione
		DatabaseManager.executeUpdate("delete from pending_annotation where worker = ?;", worker.getUsername());
		
		// Per scegliere la prossima immagine usiamo questi criteri:
		// - Deve appartenere alla campagna corrente
		// - Deve essere un'immagine approvata
		// - Non deve essere già stata annotata dall'utente corrente
		// - Deve avere annotation_request_counter < users_for_image_annotation
		// - Tra tutte le immagini che soddisfano questi criteri scegliamo quella col minor annotation_request_counter
		// Se alla fine troviamo un'immagine, registriamo la richiesta nel database
		List<Map<String, Object>> nextImageQuery = DatabaseManager.executeQuery("select url from (image join image_statistics on url = image) join campaign on campaign = name " +
																				"where annotation_request_counter < users_for_image_annotation and approved and campaign = ? and " +
																						"url not in (select image from annotation where worker = ?)" +
																				"order by annotation_request_counter asc;", campaign, worker.getUsername());
		if (!nextImageQuery.isEmpty()) {
			String nextImage = (String)nextImageQuery.get(0).get("url");
			DatabaseManager.executeUpdate("insert into pending_annotation values (?, ?, ?)", nextImage, worker.getUsername(), System.currentTimeMillis()/1000);
			return nextImage;
		} else {
			return null;
		}
	}
}
