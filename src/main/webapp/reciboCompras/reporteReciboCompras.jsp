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
        <title>Reporte recibo de compras</title>
        <link href="../css/web.css" rel="stylesheet" type="text/css" />
        
    </head>
    <body>
        
            

                <%
                
                //--------para formato de numeros------------------    
                NumberFormat nf = NumberFormat.getNumberInstance();
                DecimalFormat format = (DecimalFormat)nf;
                format.applyPattern("#,##0.00");
                
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");//HH:mm:ss
                    
                    
                    
                    String codGestion = request.getParameter("codGestion");                    
                    String nombreGestion = request.getParameter("nombreGestion");
                    String codMes = request.getParameter("codMes");
                    String nombreMes = request.getParameter("nombreMes");
                    String codEmpresa = request.getParameter("codEmpresa");
                    UtilesSesion us = new UtilesSesion();
                    us.getLogotipoEmpresa(Integer.valueOf(codEmpresa));//se carga en una variable estatica
                    
                    /*codGestion = "2020";                    
                    codMes = "2";
                    nombreMes = "Febrero";*/
                    
                    Double montoSubTotal =0.0;
                    Double rebajasObtenidas = 0.0;
                    Double montoTotal = 0.0;
                    
                    
                    System.out.println("codAnio " + codGestion + " codMes " + codMes);
                    
                    
                 
                %>
                <h3 align="center" class="outputText2">REPORTE RECIBO DE COMPRAS</h3>
            <br>
            <form>
                <table align="center" width="40%"  style="" class="outputText2" >
                    
                    <tr>
                        <td rowspan="4"  ><img src="data:image/jpg;base64,<%=us.logotipoEmpresa%>" width="200" /></td>
                        <td><b>Gestion :</b></td><td><%=nombreGestion%></td>
                    </tr>
                    <tr>
                        <td><b>Mes:</b></td><td><%=nombreMes%></td>
                    </tr>
                </table><br/><br/>
                
             <%
                     
                 
                     String consulta =   " SELECT r.cod_recibo,  p.cod_proveedor,p.nit_proveedor,p.nombre_proveedor,  r.nro_recibo,  r.fecha_recibo, r.importe_total,"
                                + "   r.descuentos_rebajas,  r.importe_cancelado,  r.glosa,  r.fecha_pago"
                                + " FROM cont.recibos_compra r "
                                + " inner join ventas.ingresos_venta i on i.cod_recibo = r.cod_recibo"
                                + " inner join ventas.almacenes_venta av on av.cod_almacen_venta = i.cod_almacen_venta"
                                + " inner join ventas.sucursal_ventas sv on sv.cod_sucursal = av.cod_sucursal_venta"
                                + " inner join public.empresa em on em.cod_empresa = sv.cod_empresa "
                                + " inner join public.proveedores p on p.cod_proveedor =  r.cod_proveedor "
                                + " cross join public.gestiones g"
                                + " where g.cod_gestion = '"+codGestion+"' and r.fecha_recibo between g.fecha_inicio and g.fecha_final"
                                + " and extract(month from r.fecha_recibo)='"+codMes+"' and em.cod_empresa = '"+codEmpresa+"' ";
                     
                     
                     System.out.println("consulta " + consulta);
                     Statement st1 = utiles.getCon().createStatement();
                     ResultSet rs1 = st1.executeQuery(consulta);
                     out.print("<div align=center>"+
                               "<table class='tablaReportes'>");
                     out.print("<tr>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>FECHA RECIBO</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NIT PROVEEDOR</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NOMBRE Y APELLIDO/RAZON SOCIAL</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NRO DE RECIBO</th>"                                                                  
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>MONTO BS.</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>REBAJAS OBTENIDAS</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>TOTAL BS.</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>GLOSA</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>FECHA DE REGISTRO</th>"                                                                  
                                 + "</tr>");
                     
                     
                         while(rs1.next()){
                             
                             out.print("<tr >"
                                     + "<td class='bordeIzquierdo'>"+sdf.format(rs1.getTimestamp("fecha_recibo"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nit_proveedor")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_proveedor")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nro_recibo")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getDouble("importe_total")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("descuentos_rebajas"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("importe_cancelado"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("glosa") +"</td>"
                                     + "<td class='bordeIzquierdo bordeDerecho'></td>"
                                     + "</tr>");
                             montoSubTotal += rs1.getDouble("importe_total");
                             rebajasObtenidas +=rs1.getDouble("descuentos_rebajas");
                             montoTotal +=rs1.getDouble("importe_cancelado");
                         }
                         out.print("<tr>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(montoSubTotal)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(rebajasObtenidas)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo bordeDerecho'>"+format.format(montoTotal)+"</td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"                                     
                                     + "</tr>");
                         out.print("</table></div>");
                     
                     
                     
                     //con.close();
                     
                     
                 
                }catch(Exception e){
                    e.printStackTrace();}
                utiles.closeConnection();
             %>
             
            
            
            
        </form>
    </body>
</html>