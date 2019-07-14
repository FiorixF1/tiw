package servlet;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import beans.User;
import start.DatabaseManager;

@WebServlet("/CreateCampaign")
@MultipartConfig
public class CreateCampaign extends HttpServlet {
	private static final long serialVersionUID = 1769720297215151002L;
	private String root;
	private String error;
	
	public CreateCampaign() {
        super();
    }
	
	public void init() throws ServletException {
        this.root = getServletContext().getInitParameter("upload_location");
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User manager = (User)request.getSession().getAttribute("user");
		if (manager == null || manager.getRole().equals("worker")) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);  // 403
			return;
		}
		
		String campaignName = request.getParameter("name");
		String usersForImageSelection = request.getParameter("users_for_image_selection");
		String leastPositiveRatings = request.getParameter("least_positive_ratings");
		String usersForImageAnnotation = request.getParameter("users_for_image_annotation");
		String linePixels = request.getParameter("line_pixels");
		String[] workersSelection = request.getParameterValues("workers_selection");
		String[] workersAnnotation = request.getParameterValues("workers_annotation");
		
		if (isInputValid(request)) {
			/* Una volta confermato l'input, ci sono diversi update da fare nel db:
			 * - aggiungere una tupla in campaign per la campagna
			 * - aggiungere varie tuple in worker_campaign per abilitare i lavoratori
			 * - aggiungere le immagini in una directory locale e poi aggiungerne il path nel db
			 */
			
			// aggiungere una tupla in campaign per la campagna
			DatabaseManager.executeUpdate("insert into campaign values (?, ?, ?, ?, ?, ?, 0);",
					campaignName, manager.getUsername(), usersForImageSelection, leastPositiveRatings, usersForImageAnnotation, linePixels);
			
			// abilitare lavoratori per il task di selezione
			for (String username : workersSelection) {
				DatabaseManager.executeUpdate("insert into worker_campaign values (?, ?, ?, ?);",
						username, campaignName, true, false);
			}
			
			// abilitare lavoratori per il task di annotazione
			for (String username : workersAnnotation) {
				String error = DatabaseManager.executeUpdate("insert into worker_campaign values (?, ?, ?, ?);",
						username, campaignName, false, true);
				/* Caso particolare: se un lavoratore viene abilitato per entrambi i task si viola
				 * il vincolo di chiave primaria. Non effettuiamo una insert ma una update.
				 */
				if (error != null) {
					DatabaseManager.executeUpdate("update worker_campaign set annotation_task = true where worker = ? and campaign = ?;",
							username, campaignName);
				}
			}
			
			// aggiungere le immagini in una directory locale e poi aggiungerne il path nel db
			File path = new File(root + File.separator + "campaigns" + File.separator + campaignName);
			if (!path.exists()) {
			    path.mkdirs();
			}
			
			List<Part> fileParts = request.getParts().stream().filter(part -> "upload_images".equals(part.getName())).collect(Collectors.toList());
		    for (Part filePart : fileParts) {
		        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

		        InputStream inputStreamFromRequestBody = filePart.getInputStream();
		        File uploadedFile = new File(path + File.separator + fileName);
		        OutputStream outputStreamToTargetFile = new FileOutputStream(uploadedFile);
		        
		        int read = 0;
			    final byte[] bytes = new byte[1024];
			    while ((read = inputStreamFromRequestBody.read(bytes)) != -1) {
			        outputStreamToTargetFile.write(bytes, 0, read);
			    }
			    
			    DatabaseManager.executeUpdate("insert into image values (?, ?);", uploadedFile.getPath(), campaignName);
			    outputStreamToTargetFile.close();
			    inputStreamFromRequestBody.close();
		    }
		    
		    response.getWriter().print("200");  // inviamo conferma che sia tutto apposto
		} else {
			response.getWriter().print(error);
		}
	}
	
	protected boolean isInputValid(HttpServletRequest request) throws ServletException, IOException {
		String name = request.getParameter("name");
		String usersForImageSelection = request.getParameter("users_for_image_selection");
		String leastPositiveRatings = request.getParameter("least_positive_ratings");
		String usersForImageAnnotation = request.getParameter("users_for_image_annotation");
		String linePixels = request.getParameter("line_pixels");
		String[] workersSelection = request.getParameterValues("workers_selection");
		String[] workersAnnotation = request.getParameterValues("workers_annotation");
		
		/* Controlli da fare:
		 * - il nome della campagna non deve essere già esistente (vincolo di chiave primaria nel db)
		 * - i parametri numerici devono essere effettivamente dei numeri interi
		 * - ogni parametro numerico deve essere maggiore di 0
		 * - i lavoratori per il primo task devono essere almeno usersForImageSelection
		 * - i lavoratori per il secondo task devono essere almeno usersForImageAnnotation
		 * - leastPositiveRatings deve essere minore o uguale a usersForImageSelection
		 * - linePixels deve essere compreso tra 1 e 10
		 * - le immagini devono essere almeno una e devono appunto essere file immagine
		 */
		
		// il nome della campagna non deve essere già esistente (vincolo di chiave primaria nel db)
		List<Map<String, Object>> existingCampaign = DatabaseManager.executeQuery("select name from campaign where name = ?;", name);
		if (!existingCampaign.isEmpty()) {
			error = "Il nome della campagna è già in uso";
			return false;
		}
		
		// i parametri numerici devono essere effettivamente dei numeri interi
		int N, K, M, PX;
		try {
			N = Integer.valueOf(usersForImageSelection);
			K = Integer.valueOf(leastPositiveRatings);
			M = Integer.valueOf(usersForImageAnnotation);
			PX = Integer.valueOf(linePixels);
			
		} catch (NumberFormatException nfe) {
			error = "Inserisci un numero valido";
			return false;
		}
		
		// ogni parametro numerico deve essere maggiore di 0
		if (N <= 0 || K <= 0 || M <= 0 || PX <= 0) {
			error = "Inserisci numeri positivi";
			return false;
		}
		
		// i lavoratori per il primo task devono essere almeno usersForImageSelection
		if (workersSelection == null || workersSelection.length < N) {
			error = "Non hai selezionato abbastanza lavoratori per la selezione";
			return false;
		}
		
		// i lavoratori per il secondo task devono essere almeno usersForImageAnnotation
		if (workersAnnotation == null || workersAnnotation.length < M) {
			error = "Non hai selezionato abbastanza lavoratori per l'annotazione";
			return false;
		}
		
		// leastPositiveRatings deve essere minore o uguale a usersForImageSelection
		if (K > N) {
			error = "Hai richiesto più voti rispetto al numero di lavoratori";
			return false;
		}
		
		// linePixels deve essere compreso tra 1 e 10
		if (PX < 1 || PX > 10) {
			error = "Line Pixels deve essere un numero compreso tra 1 e 10";
			return false;
		}
		
		// le immagini devono essere almeno una e devono appunto essere file immagine
		List<Part> fileParts = request.getParts().stream().filter(part -> "upload_images".equals(part.getName())).collect(Collectors.toList());
		if (fileParts.isEmpty()) {
			error = "Non hai selezionato immagini";
			return false;
		}
	    for (Part filePart : fileParts) {try (InputStream fileContent = filePart.getInputStream()) {
			    try {
			    	// It's an image (only BMP, GIF, JPG and PNG are recognized).
			        ImageIO.read(fileContent).toString();
			    } catch (Exception e) {
			        // It's not an image.
			    	error = "I formati delle immagini supportati sono BMP, GIF, JPG e PNG";
			    	return false;
			    }
			}
	    }
		
	    // l'input ha passato tutti i test: è valido
		return true;
	}
}