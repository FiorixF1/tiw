package beans;

import java.io.Serializable;

/**
 * Java bean per descrivere una campagna
 * Nel database le campagne sono in una tabella creata con questo comando SQL:
	CREATE TABLE campaign (
	name						VARCHAR(64) PRIMARY KEY,
	manager						VARCHAR(64) NOT NULL,
	users_for_image_selection	INT	PRIMARY KEY,
	least_positive_ratings		INT NOT NULL,
	users_for_image_annotation	INT NOT NULL,
	line_pixels					INT NOT NULL,
	active						BOOLEAN NOT NULL,
	FOREIGN KEY (manager) REFERENCES user(username) ON DELETE NO ACTION ON UPDATE CASCADE );
 * @author fiorix
 */

public class Campaign implements Serializable {
	private String name;
	private String manager;
	private int usersForImageSelection;
	private int leastPositiveRatings;
	private int usersForImageAnnotation;
	private int linePixels;
	private int isActive;

	public Campaign() {		
	}
	
	public String getName() {
		return name;
	}
	
	public void setName(String name) {
		this.name = name;
	}
	
	public String getManager() {
		return manager;
	}
	
	public void setManager(String manager) {
		this.manager = manager;
	}
	
	public int getUsersForImageSelection() {
		return usersForImageSelection;
	}
	
	public void setUsersForImageSelection(int usersForImageSelection) {
		this.usersForImageSelection = usersForImageSelection;
	}
	
	public int getLeastPositiveRatings() {
		return leastPositiveRatings;
	}
	
	public void setLeastPositiveRatings(int leastPositiveRatings) {
		this.leastPositiveRatings = leastPositiveRatings;
	}
	
	public int getUsersForImageAnnotation() {
		return usersForImageAnnotation;
	}
	
	public void setUsersForImageAnnotation(int usersForImageAnnotation) {
		this.usersForImageAnnotation = usersForImageAnnotation;
	}
	
	public int getLinePixels() {
		return linePixels;
	}
	
	public void setLinePixels(int linePixels) {
		this.linePixels = linePixels;
	}
	
	public int isActive() {
		return isActive;
	}

	public void setActive(int isActive) {
		this.isActive = isActive;
	}
}