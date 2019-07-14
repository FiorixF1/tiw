package beans;

/**
 * Java bean per descrivere un utente
 * Nel database gli utenti sono in una tabella creata con questo comando SQL:
	CREATE TABLE user (
	first_name	VARCHAR(64) NOT NULL
	last_name	VARCHAR(64) NOT NULL
	username	VARCHAR(64)	PRIMARY KEY,
	email		VARCHAR(64) NOT NULL UNIQUE,
	password	VARCHAR(64) NOT NULL,
	role		VARCHAR(16) NOT NULL );
 * Il campo role può assumere i valori 'manager' e 'worker'
 * @author fiorix
 */

public class User {
	private String firstName;
	private String lastName;
	private String username;
	private String eMail;
	private String password;
	private String role;
	
	public User() {	
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getEMail() {
		return eMail;
	}

	public void setEMail(String eMail) {
		this.eMail = eMail;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

}
