<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "java.sql.*"%> 
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Map" %>
<%@ page import = "reporte.util.Utiles" %>
<%!
    
%>

<%
    Utiles utiles = new Utiles();
    utiles.getConnection();
    try{
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        
        <%--meta http-equiv="Content-Type" content="text/html; charset=UTF-8"--%>
        <title>REPORTE</title>
        <!--link href="../css/web.css" rel="stylesheet" type="text/css" /-->
        <style type="text/css" >
            body{font-family: Arial, Helvetica, sans-serif;}
            table.paleBlueRows {
                font-family: Arial, Helvetica, sans-serif;
                border: 1px solid #FFFFFF;
                width: 80%;
                height: 200px;
                text-align: left;
                border-collapse: collapse;
              }
              table.paleBlueRows td, table.paleBlueRows th {
                border: 1px solid #FFFFFF;
                padding: 3px 2px;
              }
              table.paleBlueRows tbody td {
                font-size: 13px;
              }
              table.paleBlueRows tr:nth-child(even) {
                background: #D0E4F5;
              }
              table.paleBlueRows thead {
                background: #0B6FA4;
                border-bottom: 5px solid #FFFFFF;
              }
              table.paleBlueRows thead th {
                font-size: 17px;
                font-weight: bold;
                color: #FFFFFF;
                text-align: center;
                border-left: 2px solid #FFFFFF;
              }
              table.paleBlueRows thead th:first-child {
                border-left: none;
              }

              table.paleBlueRows tfoot {
                font-size: 14px;
                font-weight: bold;
                color: #333333;
                background: #D0E4F5;
                border-top: 3px solid #444444;
              }
              table.paleBlueRows tfoot td {
                font-size: 14px;
              }

            
        </style>
    </head>
    <body>
        <h3 align="center">REPORTE EXISTENCIAS DE PRODUCTO</h3>
        <br>
        <form>
            

                <%
                
                //--------para formato de numeros------------------    
                NumberFormat nf = NumberFormat.getNumberInstance();
                DecimalFormat format = (DecimalFormat)nf;
                format.applyPattern("#,###.00");
                
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                    

                    
                    String fechaInicio=  "01/06/2016"; //request.getParameter("fechaInicio")==null?"0":request.getParameter("fechaInicio");
                    String fechaFinal= "01/10/2017";//request.getParameter("fechaFinal")==null?"0":request.getParameter("fechaFinal");                    
                    String codMaterial="0";//request.getParameter("codMaterial")==null?"0":request.getParameter("codMaterial");
                    
                    
                    fechaInicio = request.getParameter("fechaInicio");
                    fechaFinal = request.getParameter("fechaFinal");
                    String codProducto = request.getParameter("codProducto");
                    String nombreProducto = request.getParameter("nombreProducto");
                    
                    
                    System.out.println("codProducto " + codProducto);
                    
                    
                    
                    double saldo = 0.0;
                    
                    
                 
                 
                 
                 //System.out.println("consulta " + consulta);
                 //Statement st = con.createStatement();
                 //ResultSet rs = st.executeQuery(consulta);
                 
                %>
                <table align="center" width="40%"  style="" class="dataTable_class" >
                    
                    <tr>
                        <td rowspan="4"  ><img src="../../images/imtex.jpg" width="140px"></td>
                        <td><b>Producto :</b></td><td><%=nombreProducto%></td>
                    </tr>
                    <tr>
                        <td><b>Fecha Inicio:</b></td><td><%=fechaInicio%></td>
                    </tr>
                    <tr>
                        <td ><b>Fecha Final: </b></td><td><%=fechaFinal%></td>
                    </tr>
                    <tr>
                        <td ><b>Saldo Inicial: </b></td><td><%= saldo%></td>                  
                    </tr>
                </table><br/><br/>
                
             <%
                     
                 
                     String consulta = "select m.nombre_producto,(select sum(iad.cant_restante) from ventas.ingresos_almacen_detalle iad  "
                             + " inner join ventas.ingresos_almacen ia on ia.cod_ingreso_almacen = iad.cod_ingreso_almacen"
                             + " where ia.cod_estado_ingreso_almacen = 1 and ia.cod_estado_registro = 1"
                             + " and iad.cod_producto = m.cod_producto ) restante,u.nombre_unidad_medida"
                             + " from public.productos m "
                             + " inner join public.unidades_medida u on u.cod_unidad_medida = m.cod_unidad_medida"
                             + " where m.cod_producto in("+codProducto+")  ";
                     
                     System.out.println("consulta " + consulta);
                     Statement st1 = utiles.getCon().createStatement();
                     ResultSet rs1 = st1.executeQuery(consulta);
                     out.print("<div align=center><table class='paleBlueRows'>");
                     out.print("<tr>"
                                 +"<th>PRODUCTO</th>"
                                 +"<th>EXISTENCIA</th>"
                                 +"<th>UNID.</th>"                                 
                                 + "</tr>");
                     
                     
                         while(rs1.next()){                             
                             out.print("<tr>"                                     
                                     + "<td>"+rs1.getString("nombre_producto")+"</td>"
                                     + "<td>"+format.format(rs1.getDouble("restante"))+"</td>"
                                     + "<td >"+rs1.getString("nombre_unidad_medida")+"</td>"
                                     + "</tr>");
                         }
                         out.print("</table></div>");
                     
                     
                     
                     //con.close();
                     
                     
                 
                }catch(Exception e){
                    e.printStackTrace();}
                utiles.closeConnection();
             %>
             
            
            
            
        </form>
    </body>
</html>