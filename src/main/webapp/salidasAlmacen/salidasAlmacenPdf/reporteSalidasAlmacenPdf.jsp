<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="reporte.util.*" %>



<%
    
    
    
    
    String codSalidaVenta = request.getParameter("codSalidaVenta")==null?"0":request.getParameter("codSalidaVenta");    
    
    
    String reportFileName = application.getRealPath("/salidasAlmacen/salidasAlmacenPdf/reporteSalidasAlmacen.jasper");
    System.out.println("path " + reportFileName);
    
    Utiles utiles = new Utiles();
    utiles.getConnection();
    
    Map parameters = new HashMap();
    parameters.put("cod_salida_venta",Integer.valueOf(codSalidaVenta));
    //parameters.put("SUBREPORT_DIR",application.getRealPath("/salidasAlmacen/salidasAlmacenPdf/reporteSalidasAlmacenDetalle.jasper")); //  es que ahora el path sub report es $P{SUB_REPORT}+"nombre_reporte.jasper"
    //parameters.put("logotipo",application.getRealPath("/images/logotipo.jpg"));
    
    

    System.out.println("parametros del reporte "+parameters);
    System.out.println(reportFileName + " " + parameters);
    
    JasperPrint jasperPrint =JasperFillManager.fillReport(reportFileName,parameters,utiles.getCon());//con librerias incompatibles da error aqui
    session.setAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
    utiles.closeConnection();
%>

<html>       
    <body bgcolor="white" onload="location='../../servlets/pdf'">
           
    </body>
</html>


