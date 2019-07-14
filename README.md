# Setup

Questo progetto è stato sviluppato con Eclipse Neon for Java EE Developers, utilizzando Tomcat 8.5 come web server e MySQL come DBMS.

Per deployare l'applicazione, sono necessarie le seguenti modifiche:

* Entrare nella directory d'installazione di Tomcat (su Linux /opt/tomcat) e nel file ./webapps/ROOT/index.jsp aggiungere la seguente stringa di codice:
```
    <% response.sendRedirect("/Tiw/index.jsp"); %>
```

* Nel file web.xml all'interno del progetto, impostare la directory dove salvare le immagini delle campagne.

* Tramite la command line di MySQL, importare il database. Si può fare con i seguenti comandi, laddove PATH indica il percorso in cui è salvato il file tiw.sql:
```
    mysql -u root -p
    create database tiw;
    use tiw;
    source PATH/tiw.sql;
    quit;
```

* Dentro la classe DatabaseManager.java, modificare username e password con quelli della propria installazione di MySQL.

* Importare il progetto in Eclipse: da lì sarà possibile far partire l'applicazione.

**Attenzione:** l'applicazione utilizza ```mysql-connector-java-5.1.40-bin.jar``` come driver fra Java e MySQL. Questo rende necessario installare una vecchia versione di MySQL che sia compatibile con questo driver. In alternativa, si può utilizzare una versione più recente di MySQL rimpiazzando il driver con uno compatibile.
