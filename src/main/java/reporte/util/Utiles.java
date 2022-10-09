/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package reporte.util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;
import java.util.Properties;
import javax.activation.DataHandler;
//import javax.activation.DataSource;
import javax.faces.application.FacesMessage;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.naming.InitialContext;
import javax.sql.DataSource;


/**
 *
 * @author henry
 */
public class Utiles extends Authenticator{

    String user;
    String pw;
     Connection con = null;
    public Utiles(){
    }
    public Utiles(String username,String password) {
        super();//para el correo
        
        this.user = username;
        this.pw = password;
    }
    
    public  boolean isPostBack(){
        FacesContext context = FacesContext.getCurrentInstance();
        return context.getRenderKit().getResponseStateManager().isPostback(context);
    }
    public void getConnection_heroku() throws SQLException {//conexion heroku

        try {
            if (con == null || (con != null && con.isClosed()) || validaConn() == 0) {
                System.out.println("entro a cargar nueva conexion...");
                //InitialContext ctx = new InitialContext();
                //The JDBC Data source that we just created
                //DataSource ds = (DataSource) ctx.lookup("jdbc/farmacia");
                //con = ds.getConnection();
                String url = "jdbc:postgresql://ec2-54-86-224-85.compute-1.amazonaws.com:5432/df1so21u7g9191";
                Properties props = new Properties();
                props.setProperty("user", "brpejfpttmskcz");
                props.setProperty("password", "22b827bb7f664b6724fb7229233183653b7eaf6cbd8c7483a7c0015fc7b55855");
                //props.setProperty("ssl","true");

                con = DriverManager.getConnection(url, props);

                Statement st = con.createStatement();
                //st.executeUpdate("set dateformat ymd");
                st.executeUpdate("set datestyle = 'ISO, DMY';"); //YMD
                //st.close();
                //ds.getConnection().close();
                //st.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //return con;
    }   
    public  void getConnection() throws SQLException {
        
        try {
            if (con == null || (con != null && con.isClosed()) ) {
                System.out.println("entro a cargar nueva conexion...");
                InitialContext ctx = new InitialContext();
                //The JDBC Data source that we just created
                DataSource ds = (DataSource) ctx.lookup("jdbc/farmacia");
                con = ds.getConnection();
                Statement st = con.createStatement();
                //st.executeUpdate("set dateformat ymd");
                st.executeUpdate("set datestyle = 'ISO, DMY';"); //YMD
                //st.close();
            }
            } catch (Exception e) {
                e.printStackTrace();
            }
        //return con;
  }
    public  void setAutoCommit(boolean c){
        try {
            getConnection();
            con.setAutoCommit(c);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public  void commit(){
        try {
            con.commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public  void rollback(){
        try {
            con.rollback();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public int validaConn(){
      int valor = 0;
      try {        
      
      String consulta = " select 1 valor ";
      //System.out.println("consulta " + consulta);
      Statement st = con.createStatement();
      ResultSet rs = st.executeQuery(consulta);
      if(rs.next()){
          valor = rs.getInt("valor");
      }
      } catch (Exception e) {
          e.printStackTrace();
      }
      return valor;
  }

    public Connection getCon() {
        return con;
    }

    public void setCon(Connection con) {
        this.con = con;
    }
    public void closeConnection() {
            try {
                if (this.con != null && !this.con.isClosed()) {
                    System.out.println("entro cerrar conexion");
                    this.con.close();
                    this.con = null;
                }
            } catch (Exception e) {
                e.printStackTrace();                
            }
    }    
    
  
    
    
    public  void redireccionar(String direccion){
        try {
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect(direccion);
            
            } catch (Exception e) {
                e.printStackTrace();
            }
    }
        public  void enviarMensaje(String msg) {
		FacesMessage mensaje = new FacesMessage(FacesMessage.SEVERITY_INFO, msg,  null);
		FacesContext.getCurrentInstance().addMessage(null, mensaje);
                
	}        
        public  Object getSessionBean(String name){
            Map map=FacesContext.getCurrentInstance().getExternalContext().getSessionMap();
            return map.get(name);
        }
        public  String direccionRaiz(){
            String direccion = "";
        try {
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            direccion = ext.getRealPath("/");
            
            } catch (Exception e) {
                e.printStackTrace();
            }
        return direccion;
        }
        public  Map<String, String> getRequestParams(){
            return (Map<String, String>) FacesContext.getCurrentInstance().getExternalContext().getRequestParameterMap();
            //String param = parameterMap.get("paramName");
        }
        
        public  String enviarCorreo(String correo,String mensaje,String asunto,String enviadoPor,Connection con,javax.activation.DataSource atachment){
         try {
             
             InternetAddress emails[] = new InternetAddress[1];
             
             emails[0]=new InternetAddress("servidor@imtex.com.bo");//correo
             
             Properties props = new Properties();
             props.put("mail.smtp.host", "smtp.1and1.com");
             props.put("mail.transport.protocol", "smtp");
             props.put("mail.smtp.auth", "true");
             //props.put("mail.smtp.starttls.enable", "true");
             props.put("mail.port", "587");

             props.setProperty("mail.user", "servidor@imtex.com.bo");
             props.setProperty("mail.password", "imtex2014");
             Utiles ut = new Utiles("servidor@imtex.com.bo","imtex2014");
             Session mailSession = Session.getInstance(props, ut);
             Message msg = new MimeMessage(mailSession);
             msg.setSubject(asunto);
             msg.setFrom(new InternetAddress("servidor@imtex.com.bo", enviadoPor));
             msg.addRecipients(Message.RecipientType.TO, emails);
             
             //atachment
             //DataSource source = new FileDataSource(filename);
            Multipart multipart = new MimeMultipart();
            if(atachment!=null){
            BodyPart messageBodyPart = new MimeBodyPart();
            messageBodyPart.setDataHandler(new DataHandler(atachment));
            messageBodyPart.setFileName("cotizacion.pdf");    
            multipart.addBodyPart(messageBodyPart);//pdf
            }
            
            //atachment
            

             String contenido = " <html> <head>  <title></title> " +
                     " <meta http-equiv='Content-Type' content='text/html; charset=windows-1252'> " +
                     " </head> " +
                     " <body>" + mensaje +
                     " </body> </html> " ;
             MimeBodyPart messageBodyPart1 = new MimeBodyPart();
             messageBodyPart1.setContent(contenido,"text/html");
             //multipart.addBodyPart(messageBodyPart);//pdf
             multipart.addBodyPart(messageBodyPart1);//texto
             msg.setContent(multipart);
            //msg.setContent(contenido, "text/html");
            javax.mail.Transport.send(msg);
             //System.out.println("cp "+rs.getString("nombre_correopersonal"));
             
         } catch (Exception e) {
             e.printStackTrace();
         }
         return null;
     }
     
     
    public PasswordAuthentication getPasswordAuthentication()
    {
       return new PasswordAuthentication(user, pw);
    }
        public  void copyFile(String fileName, InputStream in,String destination) {
           try {
               //String destination = "D:\\";
                // write the inputStream to a FileOutputStream
                OutputStream out = new FileOutputStream(new File(destination + fileName));
              
                int read = 0;
                byte[] bytes = new byte[1024];
              
                while ((read = in.read(bytes)) != -1) {
                    out.write(bytes, 0, read);
                }
              
                in.close();
                out.flush();
                out.close();
              
                System.out.println("New file created!");
                } catch (IOException e) {
                System.out.println(e.getMessage());
                }
    }
        
}
