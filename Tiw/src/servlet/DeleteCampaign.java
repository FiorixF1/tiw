package servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import start.DatabaseManager;

@WebServlet("/DeleteCampaign")
public class DeleteCampaign extends HttpServlet {
	private static final long serialVersionUID = -6641089970838372052L;
	private String root;
	
	public DeleteCampaign() {
        super();
    }
    
	public void init() throws ServletException {
        this.root = getServletContext().getInitParameter("upload_location");
    }
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String campaign = request.getParameter("campaign");
		
		DatabaseManager.executeUpdate("delete from campaign where name = ?;", campaign);
		
		Path path = Paths.get(root + File.separator + "campaigns" + File.separator + campaign);
		deleteFileOrFolder(path);
		
		response.setContentType("text/plain");
		response.getWriter().print("200");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

	public static void deleteFileOrFolder(final Path path) throws IOException {
		Files.walkFileTree(path, new SimpleFileVisitor<Path>() {
			@Override
			public FileVisitResult visitFile(final Path file, final BasicFileAttributes attrs) throws IOException {
				Files.delete(file);
				return FileVisitResult.CONTINUE;
			}

			@Override
			public FileVisitResult visitFileFailed(final Path file, final IOException e) {
				return handleException(e);
			}

			private FileVisitResult handleException(final IOException e) {
				e.printStackTrace();
				return FileVisitResult.TERMINATE;
			}

			@Override
			public FileVisitResult postVisitDirectory(final Path dir, final IOException e) throws IOException {
				if (e != null)
					return handleException(e);
				Files.delete(dir);
				return FileVisitResult.CONTINUE;
			}
		});
	};

}