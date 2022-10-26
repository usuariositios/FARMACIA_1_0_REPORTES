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
        <title>Reporte existencias</title>        
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
                    UtilesSesion us = new UtilesSesion();
                    us.getLogotipoEmpresa(Integer.valueOf(codEmpresa));//se carga en una variable estatica
                    
                    System.out.println("codProducto " + codProducto);
                    double saldo = 0.0;
                    
                    
                 
                 
                 
                 //System.out.println("consulta " + consulta);
                 //Statement st = con.createStatement();
                 //ResultSet rs = st.executeQuery(consulta);
                 
                %>
                <h3 align="center" class="outputText2">REPORTE EXISTENCIAS DE PRODUCTO</h3>
                <br/>
                <table align="center" width="40%"  class="outputText2"   >
                    <tr>
                        <td rowspan="4"  ><img src="<%=us.logotipoEmpresa%>" width="200" /></td>
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
                     
                 
                     String 
                     
                     consulta = "select p.codigo_producto, p.nombre_producto,tdl.nombre_campo nombre_laboratorio,ivd.nro_lote,ivd.fecha_vencimiento,ivd.cant_restante,u.nombre_unidad_medida"
                             + " from ventas.ingresos_venta_detalle ivd"
                             + " inner join ventas.ingresos_venta iv on iv.cod_ingreso_venta = ivd.cod_ingreso_venta "
                             + " inner join public.productos p on p.cod_producto = ivd.cod_producto"
                             + " left outer join( select tdl0.* from ventas.tabla_detalle tdl0  "
                             + " inner join ventas.tabla tl on tl.cod_tabla = tdl0.cod_tabla and tl.nombre_tabla = 'LABORATORIOS') tdl on tdl.cod_campo = p.cod_laboratorio "
                             + " inner join public.unidades_medida u on u.cod_unidad_medida = p.cod_unidad_medida "
                             + " where  iv.cod_estado_ingreso_venta = 1 and iv.cod_estado_registro = 1 "
                             + " and iv.cod_almacen_venta = '"+codAlmacenVenta+"' and ivd.cod_producto in ("+codProducto+") "
                             + " order by p.nombre_producto asc";
                     
                     System.out.println("consulta " + consulta);
                     Statement st1 = utiles.getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                     ResultSet rs1 = st1.executeQuery(consulta);
                     out.print("<div align=center><table class='tablaReportes'>");
                     out.print("<tr>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>Cod</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>Producto</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>Laboratorio</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>Nro Lote</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>Fecha Venc.</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>Cantidad</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>Unid.</th>"                                 
                                 + "</tr>");
                     String codigoProducto = "";
                     nombreProducto = "";
                     double totalCantRestante=0.0;
                     if(rs1.first()){
                         codigoProducto = rs1.getString("codigo_producto");
                         nombreProducto = rs1.getString("nombre_producto");
                     }
                     rs1.beforeFirst();                     
                         while(rs1.next()){                             
                             if(!codigoProducto.equals(rs1.getString("codigo_producto")) || !nombreProducto.equals(rs1.getString("nombre_producto"))){
                                out.print("<tr>"                                     
                                     + "<td class='bordeIzquierdo bordeArriba bordeAbajo' colspan='4'></td>"                                     
                                     + "<td class='bordeIzquierdo bordeArriba bordeAbajo'>Total:</td>"
                                     + "<td class='bordeIzquierdo bordeArriba bordeAbajo'>"+totalCantRestante+"</td>"                                     
                                     + "<td class='bordeIzquierdo bordeArriba bordeAbajo bordeDerecho'></td>"
                                     + "</tr>");
                                out.print("<tr>"                                     
                                     + "<td class='bordeAbajo' colspan='4'>&nbsp;</td>"                                     
                                     + "<td class='bordeAbajo'>&nbsp;</td>"
                                     + "<td class='bordeAbajo'>&nbsp;</td>"                                     
                                     + "<td class='bordeAbajo'>&nbsp;</td>"
                                     + "</tr>");
                                totalCantRestante=0.0;
                                codigoProducto = rs1.getString("codigo_producto");
                                nombreProducto = rs1.getString("nombre_producto");
                             }
                             out.print("<tr>"                                     
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("codigo_producto")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_producto")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_laboratorio")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nro_lote")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+(rs1.getTimestamp("fecha_vencimiento")!=null?sdf.format(rs1.getTimestamp("fecha_vencimiento")):"")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getDouble("cant_restante")+"</td>"                                     
                                     + "<td class='bordeIzquierdo bordeDerecho'>"+rs1.getString("nombre_unidad_medida")+"</td>"
                                     + "</tr>");
                             totalCantRestante+=rs1.getDouble("cant_restante");
                             
                             if(rs1.isLast()){
                                out.print("<tr>"                                     
                                     + "<td class='bordeIzquierdo bordeArriba bordeAbajo' colspan='4'></td>"                                     
                                     + "<td class='bordeIzquierdo bordeArriba bordeAbajo'>Total:</td>"
                                     + "<td class='bordeIzquierdo bordeArriba bordeAbajo'>"+totalCantRestante+"</td>"                                     
                                     + "<td class='bordeIzquierdo bordeArriba bordeAbajo bordeDerecho'></td>"
                                     + "</tr>");
                                
                                totalCantRestante=0.0;
                                codigoProducto = rs1.getString("codigo_producto");
                                nombreProducto = rs1.getString("nombre_producto");
                             }
                             
                             
                             
                         }
                         out.print("<tr>"
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