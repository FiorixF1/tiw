package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import start.DatabaseManager;

@WebServlet("/ActivateCampaign")
public class ActivateCampaign extends HttpServlet {
	private static final long serialVersionUID = 5015357637885943000L;

	public ActivateCampaign() {
        super();
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String campaign = request.getParameter("campaign");
		
		DatabaseManager.executeUpdate("update campaign set active = ? where name = ?;", true, campaign);
		
		response.setContentType("text/plain");
		response.getWriter().print("200");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}