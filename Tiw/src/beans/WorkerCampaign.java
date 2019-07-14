package beans;

/**
 * Java bean per descrivere l'associazione tra lavoratori e campagne
	CREATE TABLE worker_campaign (
	worker			VARCHAR(64) NOT NULL,
	campaign		VARCHAR(64) NOT NULL,
	selection_task	BOOLEAN NOT NULL,
	annotation_task	BOOLEAN NOT NULL,
	PRIMARY KEY (worker, campaign),
	FOREIGN KEY (worker) REFERENCES user(username) ON DELETE NO ACTION ON UPDATE CASCADE,
	FOREIGN KEY (campaign) REFERENCES campaign(name) ON DELETE NO ACTION ON UPDATE CASCADE );
 * @author fiorix
 */

public class WorkerCampaign {
	private String worker;
	private String campaign;
	private String manager;
	private boolean selectionTask;
	private boolean annotationTask;

	public WorkerCampaign() {		
	}
	
	public String getWorker() {
		return worker;
	}
	
	public void setWorker(String worker) {
		this.worker = worker;
	}
	
	public String getCampaign() {
		return campaign;
	}
	
	public void setCampaign(String campaign) {
		this.campaign = campaign;
	}
	
	public boolean getSelectionTask() {
		return selectionTask;
	}
	
	public void setSelectionTask(boolean selectionTask) {
		this.selectionTask = selectionTask;
	}
	
	public boolean getAnnotationTask() {
		return annotationTask;
	}
	
	public void setAnnotationTask(boolean annotationTask) {
		this.annotationTask = annotationTask;
	}
	
	public String getManager() {
		return manager;
	}
	
	public void setManager(String manager) {
		this.manager = manager;
	}
}
