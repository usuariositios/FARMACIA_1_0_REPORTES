<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="reporte.util.*" %>


<%!
public String obtieneDatosQR(String codSalidaVenta) throws Exception{

String datosQR = "";
Utiles utiles = new Utiles();
utiles.getConnection();
try{
    
    Statement st = utiles.getCon().createStatement();
    String consulta = "select e.ruc||','||f.nro_factura||','||fd.nro_autorizacion||','||to_char(f.fecha_factura,'DD/MM/YYYY')||','||"
                        + " round(cast(s.monto_total as numeric),2)||','||round(cast(s.monto_total as numeric),2)||','||f.codigo_control||','||c.nit_cliente||',0,0,0,0' datos_qr"
                        + " from"
                        + " public.empresa e"
                        + " cross join ventas.salidas_venta s"
                        + " inner join ventas.facturas_emitidas f on f.cod_salida_venta = s.cod_salida_venta"
                        + " inner join ventas.facturas_dosificacion fd on fd.cod_dosificacion = f.cod_dosificacion"
                        + " inner join public.ciudad cd on cd.cod_ciudad = e.cod_ciudad"
                        + " left outer join public.clientes c on c.cod_cliente = s.cod_cliente where s.cod_salida_venta = '"+codSalidaVenta+"' ";
    System.out.println(consulta);
    ResultSet rs = st.executeQuery(consulta);
    if(rs.next()){
    datosQR = rs.getString("datos_qr");
    }

        


    }catch(Exception e){
    e.printStackTrace();
    }
    utiles.closeConnection();
return datosQR;
}
%>
<%
    
    
    
    
    String codSalidaVenta = request.getParameter("codSalidaVenta")==null?"0":request.getParameter("codSalidaVenta");    
    String codFacturaEmitida = request.getParameter("codFacturaEmitida")==null?"0":request.getParameter("codFacturaEmitida");
    
    String montoTotal = request.getParameter("montoTotal")==null?"0":request.getParameter("montoTotal");
    String codGestion = request.getParameter("codGestion")==null?"0":request.getParameter("codGestion");
    
    
    System.out.println("codSalidaVenta "+codSalidaVenta);

    Utiles utiles = new Utiles();
    utiles.getConnection();
    N2t n2t = new N2t();
    
    System.out.println("montoTotal "+montoTotal);
    
    Double montoTotald = Double.valueOf(montoTotal);
    Double valorDecimal = montoTotald - Math.floor(montoTotald);
    valorDecimal = Math.round(valorDecimal*100.0)/100.0;
    
    valorDecimal = valorDecimal *100;
    
    String descrMonto = "";
    if(valorDecimal>0){
        descrMonto = n2t.convertirLetras(montoTotald.intValue()).toUpperCase()+" CON "+valorDecimal.intValue()+"/100 Bs.";
    }else{
        descrMonto = n2t.convertirLetras(montoTotald.intValue()).toUpperCase()+" CON 0/100 Bs.";
    }
    
    String consulta ="update ventas.facturas_emitidas set descr_monto_total='"+descrMonto +"'  where cod_factura_emitida = '"+codFacturaEmitida+"'";
    System.out.println(consulta);
    Statement st1 = utiles.getCon().createStatement();
    st1.executeUpdate(consulta);
    
    String reportFileName = application.getRealPath("/factura/reporte_factura.jasper");
    System.out.println("path " + reportFileName);
    File reportFile = new File(reportFileName);
    if (!reportFile.exists())
        throw new JRRuntimeException("El Reporte no existe");
    String datosQR = obtieneDatosQR(codSalidaVenta);
    
    Map parameters = new HashMap();
    parameters.put("COD_SALIDA_VENTA",Integer.valueOf(codSalidaVenta));
    parameters.put("SUBREPORT_DIR",application.getRealPath("/factura/reporte_factura_detalle.jasper")); //  es que ahora el path sub report es $P{SUB_REPORT}+"nombre_reporte.jasper"
    parameters.put("logotipo",application.getRealPath("/images/logotipo.jpg"));
    parameters.put("QR_DIR","https://farmacia-reportes.herokuapp.com/servlets/qr?datosQR="+datosQR);
    

    System.out.println("parametros del reporte "+parameters);
    
    System.out.println(reportFileName + " " + parameters );
    
    JasperPrint jasperPrint =JasperFillManager.fillReport(reportFileName,parameters,utiles.getCon());//con librerias incompatibles da error aqui
    session.setAttribute(BaseHttpServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
    utiles.closeConnection();
%>

<html>


       
    <body bgcolor="white" onload="location='../servlets/pdf'">
           
    </body>
</html>


