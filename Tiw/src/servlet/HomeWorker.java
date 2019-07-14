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

import beans.User;
import start.DatabaseManager;
import beans.WorkerCampaign;

@WebServlet("/HomeWorker")
public class HomeWorker extends HttpServlet {
	private static final long serialVersionUID = -3507341760088900086L;

	public HomeWorker() {
        super();
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// pagina home del Worker
		User user = (User)request.getSession().getAttribute("user");
		if (user == null || user.getRole().equals("manager")) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);  // 403
			return;
		}
		
		List<Map<String, Object>> workerCampaigns = DatabaseManager.executeQuery("select * from worker_campaign as wc join campaign as c on wc.campaign = c.name where worker = ? and active;",
				user.getUsername());

		List<WorkerCampaign> workerCampaignBeans = new ArrayList<WorkerCampaign>();
		for (Map<String, Object> workerCampaign : workerCampaigns) {
			WorkerCampaign workerCampaignBean = new WorkerCampaign();

			workerCampaignBean.setWorker((String)workerCampaign.get("worker"));
			workerCampaignBean.setCampaign((String)workerCampaign.get("campaign"));
			workerCampaignBean.setManager((String)workerCampaign.get("manager"));
			workerCampaignBean.setSelectionTask((boolean)workerCampaign.get("selection_task"));
			workerCampaignBean.setAnnotationTask((boolean)workerCampaign.get("annotation_task"));
			
			workerCampaignBeans.add(workerCampaignBean);
		}

		request.getSession().setAttribute("worker_campaign_beans", workerCampaignBeans);
		request.getServletContext().getRequestDispatcher("/home_worker.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}