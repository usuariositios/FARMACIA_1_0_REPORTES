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
<%@ page import = "reporte.util.UtilesSesion" %>
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
        <title>Reporte Productos Vencidos</title>        
        <link href="../css/web.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        
        <br>
        <form>
                <%
                
                //--------para formato de numeros------------------    
                NumberFormat nf = NumberFormat.getNumberInstance();
                DecimalFormat format = (DecimalFormat)nf;
                format.applyPattern("#,###.00");
                
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");//HH:mm:ss
                    

                    
                    String fechaInicio=  "01/06/2016"; //request.getParameter("fechaInicio")==null?"0":request.getParameter("fechaInicio");
                    String fechaFinal= "01/10/2017";//request.getParameter("fechaFinal")==null?"0":request.getParameter("fechaFinal");                    
                    
                    fechaInicio = request.getParameter("fechaInicio");
                    fechaFinal = request.getParameter("fechaFinal");
                    String codProducto = request.getParameter("codProducto");
                    String nombreProducto = request.getParameter("nombreProducto");
                    String codAlmacenVenta = request.getParameter("codAlmacenVenta");
                    String codEmpresa = request.getParameter("codEmpresa");
                    String codGestion = request.getParameter("codGestion");
                    String diasPorVencer = request.getParameter("diasPorVencer")==null?"0":request.getParameter("diasPorVencer");
                    
                    UtilesSesion us = new UtilesSesion();
                    us.getLogotipoEmpresa(Integer.valueOf(codEmpresa));//se carga en una variable estatica
                    
                    System.out.println("codProducto " + codProducto);
                    double saldo = 0.0;
                    
                    
                 
                 
                 
                 //System.out.println("consulta " + consulta);
                 //Statement st = con.createStatement();
                 //ResultSet rs = st.executeQuery(consulta);
                 
                %>
                <h3 align="center" class="outputText2">REPORTE DE PRODUCTOS VENCIDOS</h3>
                <br/>
                <!--table align="center" width="40%"  class="outputText2"   >
                    <tr>
                        <td rowspan="4"  ><img src="<%=us.logotipoEmpresa%>" width="200" /></td>
                        <td><b>Almacen :</b></td><td><%=nombreProducto%></td>
                    </tr>
                    <tr>
                        <td><b>A fecha:</b></td><td><%=fechaInicio%></td>
                    </tr>                    
                </table-->
             <br/><br/>                
             <%
                     
                 
                     String consulta = " select p.codigo_producto, p.nombre_producto,p.observaciones,ivd.fecha_vencimiento,e.nombre_estado_registro,extract(day from CURRENT_DATE - ivd.fecha_vencimiento) dias_vencidos,ivd.cant_restante "
                             + " from ventas.ingresos_venta_detalle ivd"
                             + " inner join ventas.ingresos_venta iv on ivd.cod_ingreso_venta = iv.cod_ingreso_venta"
                             + " inner join public.productos p on p.cod_producto = ivd.cod_producto"
                             + " inner join public.estados_registro e on e.cod_estado_registro = ivd.cod_estado_registro"
                             + " where ivd.fecha_vencimiento<=CURRENT_DATE and iv.cod_almacen_venta = '"+codAlmacenVenta+"'"
                             + " and ivd.cant_restante>0  and iv.cod_gestion = '"+codGestion+"'"
                             + " order by dias_vencidos desc ";
                     
                     consulta = " SELECT * FROM (  SELECT P.CODIGO_PRODUCTO,P.NOMBRE_PRODUCTO,P.OBSERVACIONES,IVD.FECHA_VENCIMIENTO,"
                             + "	E.NOMBRE_ESTADO_REGISTRO, EXTRACT(DAY	"
                             + " FROM CURRENT_DATE - IVD.FECHA_VENCIMIENTO) DIAS_VENCIDOS,"
                             + "	EXTRACT(DAY	FROM IVD.FECHA_VENCIMIENTO  - CURRENT_DATE) DIAS_POR_VENCER,"
                             + "	IVD.CANT_RESTANTE"
                             + " FROM VENTAS.INGRESOS_VENTA_DETALLE IVD"
                             + " INNER JOIN VENTAS.INGRESOS_VENTA IV ON IVD.COD_INGRESO_VENTA = IV.COD_INGRESO_VENTA"
                             + " INNER JOIN PUBLIC.PRODUCTOS P ON P.COD_PRODUCTO = IVD.COD_PRODUCTO"
                             + " INNER JOIN PUBLIC.ESTADOS_REGISTRO E ON E.COD_ESTADO_REGISTRO = IVD.COD_ESTADO_REGISTRO"
                             + " WHERE IV.COD_ALMACEN_VENTA = '"+codAlmacenVenta+"'"
                             + "	AND IVD.CANT_RESTANTE > 0	AND IV.COD_GESTION = '"+codGestion+"' "
                             + " ORDER BY DIAS_POR_VENCER ASC ) A WHERE A.DIAS_POR_VENCER <="+diasPorVencer+" ";
                     
                     System.out.println("consulta " + consulta);
                     Statement st1 = utiles.getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                     ResultSet rs1 = st1.executeQuery(consulta);
                     out.print("<div align=center><table class='tablaReportes'>");
                     out.print("<tr>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>Cod Producto</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>Nombre</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>Observaciones</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>Fecha Vencimiento</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>Estado</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>Dias Por Vencer</th>"                                 
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>Dias Vencidos</th>"                                 
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>Cantidad</th>"                                 
                                 + "</tr>");
                                         
                         while(rs1.next()){                             
                             
                             out.print("<tr>"                                     
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("codigo_producto")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_producto")+"</td>"                                     
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("observaciones")+"</td>" 
                                     + "<td class='bordeIzquierdo'>"+(rs1.getTimestamp("fecha_vencimiento")!=null?sdf.format(rs1.getTimestamp("fecha_vencimiento")):"")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_estado_registro")+"</td>"                                                                          
                                     + "<td class='bordeIzquierdo'>"+(rs1.getInt("dias_por_vencer")<0?"VENCIDO":rs1.getInt("dias_por_vencer"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+(rs1.getInt("dias_vencidos")<0?"VIGENTE":rs1.getInt("dias_vencidos"))+"</td>"
                                     + "<td class='bordeIzquierdo bordeDerecho'>"+rs1.getDouble("cant_restante")+"</td>"
                                     + "</tr>");
                         }
                         out.print("<tr>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"                                     
                                     + "</tr>");
                         out.print("</table></div>");
                     rs1.close();
                     
                     
                     //con.close();
                     
                     
                 
                }catch(Exception e){
                    e.printStackTrace();}
                utiles.closeConnection();

             %>
             
            
            
            
        </form>
    </body>
</html>