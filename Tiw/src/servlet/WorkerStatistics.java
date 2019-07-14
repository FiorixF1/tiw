package servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.Campaign;
import beans.User;
import start.DatabaseManager;

@WebServlet("/WorkerStatistics")
public class WorkerStatistics extends HttpServlet {
	private static final long serialVersionUID = -2549625502972103098L;

	public WorkerStatistics() {
        super();
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User user = (User)request.getSession().getAttribute("user");
		if (user == null || user.getRole().equals("manager")) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);  // 403
			return;
		}
		
		// estrai dati della campagna in analisi
		List<Map<String, Object>> campaignQuery = DatabaseManager.executeQuery("select * from campaign where name = ?;", request.getParameter("campaign"));
		Campaign campaign;
		if (!campaignQuery.isEmpty()) {
			campaign = new Campaign();
					
			campaign.setName((String)campaignQuery.get(0).get("name"));
			campaign.setManager((String)campaignQuery.get(0).get("manager"));
			campaign.setUsersForImageSelection((int)campaignQuery.get(0).get("users_for_image_selection"));
			campaign.setLeastPositiveRatings((int)campaignQuery.get(0).get("least_positive_ratings"));
			campaign.setUsersForImageAnnotation((int)campaignQuery.get(0).get("users_for_image_annotation"));
			campaign.setLinePixels((int)campaignQuery.get(0).get("line_pixels"));
			campaign.setActive((int)campaignQuery.get(0).get("active"));
		} else {
			// se la campagna selezionata non esiste ritorna un errore
			response.sendError(422);  // 422 (Unprocessable Entity)
			return;
		}
				
		// cerca i task ai quali è abilitato il lavoratore
		boolean enabledToSelection = false;
		boolean enabledToAnnotation = false;
		
		List<Map<String, Object>> enabledToTasks = DatabaseManager.executeQuery("select selection_task, annotation_task from worker_campaign where campaign = ? and worker = ?;",
									  											 campaign.getName(), user.getUsername());
		if (!enabledToTasks.isEmpty()) {
			enabledToSelection = (boolean)enabledToTasks.get(0).get("selection_task");
			enabledToAnnotation = (boolean)enabledToTasks.get(0).get("annotation_task");
		}
		
		// calcola le statistiche
		Long numOfAcceptedImages = null;
		Long numOfDiscardedImages = null;
		Long numOfImagesToSelect = null;
		Long numOfAnnotatedImages = null;
		Long numOfImagesToAnnotate = null;
		
		if (enabledToSelection) {
			// numero di immagini accettate
			List<Map<String, Object>> numOfAcceptedImagesQuery = DatabaseManager.executeQuery("select count(*) as result from worker_campaign as wc join rating as r on wc.worker = r.worker join image as i on r.image = i.url and wc.campaign = i.campaign where wc.worker = ? and wc.campaign = ? and rating = 1;",
																							   user.getUsername(), campaign.getName());
			if (!numOfAcceptedImagesQuery.isEmpty()) {
				numOfAcceptedImages = (Long)numOfAcceptedImagesQuery.get(0).get("result");
			}

			// numero di immagini rifiutate
			List<Map<String, Object>> numOfDiscardedImagesQuery = DatabaseManager.executeQuery("select count(*) as result from worker_campaign as wc join rating as r on wc.worker = r.worker join image as i on r.image = i.url and wc.campaign = i.campaign where wc.worker = ? and wc.campaign = ? and rating = 0;",
																								user.getUsername(), campaign.getName());
			if (!numOfDiscardedImagesQuery.isEmpty()) {
				numOfDiscardedImages = (Long)numOfDiscardedImagesQuery.get(0).get("result");
			}

			// numero di immagini da selezionare
			// non basta prendere le immagini che l'utente non ha selezionato: bisogna prendere le immagini che
			// l'utente non ha selezionato e che NON hanno raggiunto il numero sufficiente di voti (totali e positivi)
			List<Map<String, Object>> numOfImagesToSelectQuery = DatabaseManager.executeQuery("select count(*) as result from image as i join image_statistics as istat on i.url = istat.image where campaign = ? and number_of_ratings < ? and positive_ratings < ? and url not in "
																						   + "(select image from rating where worker = ?);",
																						   	   campaign.getName(), campaign.getUsersForImageSelection(), campaign.getLeastPositiveRatings(), user.getUsername());
			if (!numOfImagesToSelectQuery.isEmpty()) {
				numOfImagesToSelect = (Long)numOfImagesToSelectQuery.get(0).get("result");
			}
		}

		if (enabledToAnnotation) {
			// numero di immagini annotate
			List<Map<String, Object>> numOfAnnotatedImagesQuery = DatabaseManager.executeQuery("select count(*) as result from worker_campaign as wc join annotation as a on wc.worker = a.worker join image as i on a.image = i.url and wc.campaign = i.campaign where wc.worker = ? and wc.campaign = ?;",
																								user.getUsername(), campaign.getName());
			if (!numOfAnnotatedImagesQuery.isEmpty()) {
				numOfAnnotatedImages = (Long)numOfAnnotatedImagesQuery.get(0).get("result");
			}

			// numero di immagini da annotare
			// anche qui non basta prendere le immagini che l'utente non ha annotato:
			// tra queste bisogna considerare solo quelle che non hanno ancora raggiunto il numero minimo di annotazioni
			List<Map<String, Object>> numOfImagesToAnnotateQuery = DatabaseManager.executeQuery("select count(*) as result from image as i join image_statistics as istat on i.url = istat.image where campaign = ? and approved and number_of_annotations < ? and url not in "
																							 + "(select image from annotation where worker = ?);",
																							     campaign.getName(), campaign.getUsersForImageAnnotation(), user.getUsername());
			if (!numOfImagesToAnnotateQuery.isEmpty()) {
				numOfImagesToAnnotate = (Long)numOfImagesToAnnotateQuery.get(0).get("result");
			}
		}
		
		request.setAttribute("num_of_accepted_images", numOfAcceptedImages);
		request.setAttribute("num_of_discarded_images", numOfDiscardedImages);
		request.setAttribute("num_of_annotated_images", numOfAnnotatedImages);
		request.setAttribute("num_of_images_to_select", numOfImagesToSelect);
		request.setAttribute("num_of_images_to_annotate", numOfImagesToAnnotate);
		request.getServletContext().getRequestDispatcher("/worker_statistics.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}