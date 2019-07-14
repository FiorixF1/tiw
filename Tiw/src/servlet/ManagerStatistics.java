package servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.Campaign;
import beans.Image;
import beans.User;
import start.DatabaseManager;

@WebServlet("/ManagerStatistics")
public class ManagerStatistics extends HttpServlet {
	private static final long serialVersionUID = -6143390315208447014L;

	public ManagerStatistics() {
        super();
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User user = (User)request.getSession().getAttribute("user");
		if (user == null || user.getRole().equals("worker")) {
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
		
		// calcola le statistiche
		Integer numOfAcceptedImages = null;
		Integer numOfDiscardedImages = null;
		Integer numOfAnnotatedImages = null;
		BigDecimal averageNumOfAnnotationsForImage = null;
		
		List<Image> acceptedImages = null;
		List<Image> discardedImages = null;
		
		// numero di immagini accettate nella campagna con lista
		List<Map<String, Object>> numOfAcceptedImagesQuery = DatabaseManager.executeQuery("select * from image as i join image_statistics as istat on i.url = istat.image where i.campaign = ? and approved = 1;",
																						   campaign.getName());
		if (!numOfAcceptedImagesQuery.isEmpty()) {
			numOfAcceptedImages = numOfAcceptedImagesQuery.size();
			
			acceptedImages = new ArrayList<Image>();
			for (Map<String, Object> tuple : numOfAcceptedImagesQuery) {
				Image currentImage = new Image();
				
				currentImage.setAbsolutePath((String)tuple.get("url"));
				currentImage.setPositiveRatings((BigDecimal)tuple.get("positive_ratings"));
				currentImage.setNegativeRatings((BigDecimal)tuple.get("negative_ratings"));
				
				acceptedImages.add(currentImage);
			}
		}

		// numero di immagini rifiutate nella campagna con lista
		// non basta che approved sia a zero, perché quello è il valore di default di tutte le immagini
		// un'immagine è scartata se approved = 0 dopo aver raggiunto il numero minimo di voti (dato da users_for_image_selection)
		List<Map<String, Object>> numOfDiscardedImagesQuery = DatabaseManager.executeQuery("select * from image as i join image_statistics as istat on i.url = istat.image where i.campaign = ? and approved = 0 and number_of_ratings >= ?;",
																						    campaign.getName(), campaign.getUsersForImageSelection());
		if (!numOfDiscardedImagesQuery.isEmpty()) {
			numOfDiscardedImages = numOfDiscardedImagesQuery.size();
			
			discardedImages = new ArrayList<Image>();
			for (Map<String, Object> tuple : numOfDiscardedImagesQuery) {
				Image currentImage = new Image();
				
				currentImage.setAbsolutePath((String)tuple.get("url"));
				currentImage.setPositiveRatings((BigDecimal)tuple.get("positive_ratings"));
				currentImage.setNegativeRatings((BigDecimal)tuple.get("negative_ratings"));
				
				discardedImages.add(currentImage);
			}
		}
		
		// numero di immagini annotate
		// solo le immagini accettate possono avere annotazioni, quindi per ognuna di esse
		// cerchiamo le relative annotazioni e le inseriamo nel bean
		List<Map<String, Object>> numOfAnnotatedImagesQuery = DatabaseManager.executeQuery("select * from image as i join image_statistics as istat on i.url = istat.image where i.campaign = ? and number_of_annotations > 0;",
																						    campaign.getName());
		if (!numOfAnnotatedImagesQuery.isEmpty()) {
			numOfAnnotatedImages = numOfAnnotatedImagesQuery.size();
			
			for (Image img : acceptedImages) {
				String imagePath = img.getAbsolutePath();
				
				List<Map<String, Object>> imageAnnotations = DatabaseManager.executeQuery("select url, worker from annotation where image = ?;", imagePath);
				if (!imageAnnotations.isEmpty()) {
					for (Map<String, Object> tuple : imageAnnotations) {
						// ottieni lavoratore dell'annotazione
						String worker = (String)tuple.get("worker");
						// ottieni percorso del file con l'annotazione
						String annotationPath = (String)tuple.get("url");
						// leggi il file
						String annotation = new String(Files.readAllBytes(Paths.get(annotationPath)), StandardCharsets.UTF_8);
						// e ficcalo nel bean
						img.addAnnotation(worker, annotation);
					}
				}
			}
		}

		// numero medio di annotazioni per immagine
		List<Map<String, Object>> averageNumOfAnnotationsForImageQuery = DatabaseManager.executeQuery("select avg(number_of_annotations) as result from image as i join image_statistics as istat on i.url = istat.image where approved and i.campaign = ?;",
																						   campaign.getName());
		if (!averageNumOfAnnotationsForImageQuery.isEmpty()) {
			averageNumOfAnnotationsForImage = (BigDecimal)averageNumOfAnnotationsForImageQuery.get(0).get("result");
		}
		
		request.setAttribute("campaign", campaign);
		
		request.setAttribute("num_of_accepted_images", numOfAcceptedImages);
		request.setAttribute("num_of_discarded_images", numOfDiscardedImages);
		request.setAttribute("num_of_annotated_images", numOfAnnotatedImages);
		request.setAttribute("average_num_of_annotations_for_image", averageNumOfAnnotationsForImage);
		
		request.setAttribute("accepted_images", acceptedImages);
		request.setAttribute("discarded_images", discardedImages);
		request.getServletContext().getRequestDispatcher("/manager_statistics.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}