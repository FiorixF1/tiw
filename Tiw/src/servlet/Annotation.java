package servlet;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



import beans.User;
import start.DatabaseManager;

@WebServlet("/Annotation")
public class Annotation extends HttpServlet {
	private static final long serialVersionUID = -5412004314637216444L;
	private String root;
       
    public Annotation() {
        super();
    }
    
    public void init() throws ServletException {
    	this.root = getServletContext().getInitParameter("upload_location");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	User worker = (User)request.getSession().getAttribute("user");
		if (worker == null || worker.getRole().equals("manager")) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);  // 403
			return;
		}
    	
		String imageName = request.getParameter("image_name");
		String jsonAnnotation = request.getParameter("json_annotation");
		String campaign = request.getParameter("campaign");
    	
		// Controllo della validità dell'annotazione tramite un'espressione regolare
		String pattern = "\\{\"worker\":\".+\",\"width\":\\d+,\"height\":\\d+,\"x\":\\[.+\\],\"y\":\\[.+],\"drag\":\\[.+\\]\\}";
		Pattern re = Pattern.compile(pattern);
		Matcher match = re.matcher(jsonAnnotation);
		if (!match.find()) {
			response.sendError(422);  // 422 (Unprocessable Entity)
			return;
		}

    	// Recupera la directory della campagna in cui salvare le annotazioni
    	File path = new File(root + File.separator + "campaigns" + File.separator + campaign);
    	if (!path.exists()) {
    		path.mkdirs();
    	}
    	
    	// Salviamo l'annotazione in un file .json su disco
    	String imageFile = path + File.separator + imageName;
    	String annotationFile = imageFile + "_" + worker.getUsername()+ ".json";
    	PrintWriter uploadedFile = new PrintWriter(annotationFile, "UTF-8");
    	uploadedFile.print(jsonAnnotation);
    	uploadedFile.close();
    	
    	// Cancella l'annotazione pendente dal database, dato che è stata ricevuta
    	DatabaseManager.executeUpdate("delete from pending_annotation where worker = ? and image = ?;", worker.getUsername(), imageFile);		
    	// E inserisci l'annotazione vera e propria
    	DatabaseManager.executeUpdate("insert into annotation values (?, ?, ?);", annotationFile, imageFile, worker.getUsername());

    	request.getServletContext().getRequestDispatcher("/AnnotationTask").forward(request, response);
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
