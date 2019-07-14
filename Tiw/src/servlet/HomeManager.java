package servlet;

import java.io.IOException;
import java.util.ArrayList;
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

@WebServlet("/HomeManager")
public class HomeManager extends HttpServlet {
	private static final long serialVersionUID = -3507341760088900086L;

	public HomeManager() {
        super();
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// pagina home del Manager
		User user = (User)request.getSession().getAttribute("user");
		if (user == null || user.getRole().equals("worker")) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);  // 403
			return;
		}
		
		List<Map<String, Object>> campaigns = DatabaseManager.executeQuery("select * from campaign where manager = ?;",
				user.getUsername());
	
		List<Campaign> campaignBeans = new ArrayList<Campaign>();
		for (Map<String, Object> campaign : campaigns) {
			Campaign campaignBean = new Campaign();
			
			campaignBean.setName((String)campaign.get("name"));
			campaignBean.setManager((String)campaign.get("manager"));
			campaignBean.setUsersForImageSelection((int)campaign.get("users_for_image_selection"));
			campaignBean.setLeastPositiveRatings((int)campaign.get("least_positive_ratings"));
			campaignBean.setUsersForImageAnnotation((int)campaign.get("users_for_image_annotation"));
			campaignBean.setLinePixels((int)campaign.get("line_pixels"));
			campaignBean.setActive((int)campaign.get("active"));
			
			campaignBeans.add(campaignBean);
		}
		
		List<Map<String, Object>> workers = DatabaseManager.executeQuery("select username from user where role = 'worker' order by username asc;");
		List<String> workerUsernames = new ArrayList<String>();
		for (Map<String, Object> worker : workers) {
			String workerUsername = (String)worker.get("username");
			workerUsernames.add(workerUsername);
		}
		
		request.getSession().setAttribute("campaign_beans", campaignBeans);
		request.getSession().setAttribute("worker_usernames", workerUsernames);
		request.getServletContext().getRequestDispatcher("/home_manager.jsp").forward(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}