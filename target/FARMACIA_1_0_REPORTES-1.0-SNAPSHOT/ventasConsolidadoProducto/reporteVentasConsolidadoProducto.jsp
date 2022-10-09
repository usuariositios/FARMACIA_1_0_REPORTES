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
        <title>Ventas consolidado por producto</title>
        <link href="../css/web.css" rel="stylesheet" type="text/css" />
        
    </head>
    <body>
        
            

                <%
                
                //--------para formato de numeros------------------    
                NumberFormat nf = NumberFormat.getNumberInstance();
                DecimalFormat format = (DecimalFormat)nf;
                format.applyPattern("#,##0.00");
                
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");//HH:mm:ss
                    
                    
                    
                    String fechaInicio = request.getParameter("fechaInicio");
                    String fechaFinal = request.getParameter("fechaFinal");
                    String codPersonal = request.getParameter("codPersonal");//persona que vende
                    String codCliente = request.getParameter("codCliente");
                    String codProducto = request.getParameter("codProducto");
                    String codEmpresa = request.getParameter("codEmpresa");
                    String codSubGrupo = request.getParameter("codSubGrupo");
                    
                    /*codProducto = "0";
                    codPersonal = "0";
                    codCliente = "0";
                    codSubGrupo = "0";*/
                            
                    /*fechaInicio = "01/01/2020";
                    fechaFinal = "31/12/2020";
                    codEmpresa = "24";*/
                    
                    double cantSalida = 0.0;
                    double montoSubTotal = 0.0;
                    double montoDescuento = 0.0;
                    double montoTotal = 0.0;
                    double montoEsperado = 0.0;
                    
                    
                    UtilesSesion us = new UtilesSesion();
                    us.getLogotipoEmpresa(Integer.valueOf(codEmpresa));//se carga en una variable estatica
                    
                    //System.out.println("codAnio " + codGestion + " codMes " + codMes);
                    
                    
                 
                %>
                <h3 align="center" class="outputText2">REPORTE VENTAS CONSOLIDADO POR PRODUCTO</h3>
            <br>
            <form>
                    <table align="center"  width="40%"  style="" class="outputText2" >
                        <tr>
                            <td rowspan="2" width="140px"  ><img src="data:image/jpg;base64,<%=us.logotipoEmpresa%>" width="200" /></td>
                            <td><b>Cliente :</b></td><td><%=""%></td>
                        </tr>
                        <tr>
                            <td><b>Tipo de Venta:</b></td><td><%=""%></td>
                        </tr>
                    </table>                
                    <br/><br/>
                
             <%
                     
                 
                     String consulta = " SELECT p.codigo_producto, p.nombre_producto,g.nombre_grupo_producto"
                             + " ,sum(sd.cant_salida) cant_salida,sum(sd.monto_sub_total) monto_sub_total,sum(sd.porc_descuento/100*sd.monto_sub_total) monto_descuento,sum(sd.monto_total) monto_total,sum( sd.cant_salida*sd.costo_unitario) monto_esperado,em.cod_empresa"
                             + "  FROM   ventas.facturas_emitidas f"
                             + "  inner join ventas.salidas_venta s on s.cod_salida_venta = f.cod_salida_venta"
                             + "  inner join ventas.salidas_venta_detalle sd on sd.cod_salida_venta = s.cod_salida_venta"
                             + "  inner join public.productos p on p.cod_producto = sd.cod_producto"
                             + "  inner join public.grupo_producto g on g.cod_grupo_producto = p.cod_grupo_producto"
                             + "  inner join public.clientes c on c.cod_cliente = s.cod_cliente"
                             + "  inner join ventas.almacenes_venta av on av.cod_almacen_venta = s.cod_almacen_venta"
                             + "  inner join ventas.sucursal_ventas sv on sv.cod_sucursal = av.cod_sucursal_venta"
                             + "  inner join public.empresa em on em.cod_empresa = sv.cod_empresa"
                             + "  inner join public.estados_registro e   on e.cod_estado_registro = f.cod_estado_registro"
                             + "  left outer join public.personal per on per.cod_personal = s.cod_personal_venta"
                             + "  where 0=0 and f.fecha_factura between '"+fechaInicio+"' and '"+fechaFinal+"' and em.cod_empresa='"+codEmpresa+"' and sd.cod_producto in("+codProducto+")"
                             + "  ";
                     
                     
                     
                     consulta+= " group by p.codigo_producto, p.nombre_producto,g.nombre_grupo_producto,em.cod_empresa  ";                     
                     consulta +=" order by p.codigo_producto asc ";
                     
                     System.out.println("consulta " + consulta);
                     Statement st1 = utiles.getCon().createStatement();
                     ResultSet rs1 = st1.executeQuery(consulta);
                     out.print("<div align=center>"+
                               "<table class='tablaReportes'>");
                     out.print("<tr>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>CODIGO <br> PRODUCTO</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NOMBRE <br> PRODUCTO</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>GRUPO</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>CANTIDAD</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>SUB TOTAL BS</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>DESCUENTO BS</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>TOTAL BS</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>ESPERADO BS</th>"                                 
                                 + "</tr>");
                     
                     
                         while(rs1.next()){
                             
                             out.print("<tr >"                                     
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("codigo_producto")+"</td>"                                     
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_producto")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_grupo_producto")+"</td>"                                     
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("cant_salida"))+"</td>"                                     
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_sub_total")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_descuento")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_total")) +"</td>"
                                     + "<td class='bordeIzquierdo bordeDerecho'>"+format.format(rs1.getDouble("monto_esperado")) +"</td>"                                     
                                     + "</tr>");
                             cantSalida+=rs1.getDouble("cant_salida");
                             montoSubTotal +=rs1.getDouble("monto_sub_total");
                             montoDescuento +=rs1.getDouble("monto_descuento");
                             montoTotal += rs1.getDouble("monto_total");
                             montoEsperado +=rs1.getDouble("monto_esperado");
                             
                             
                                
                         }
                         out.print("<tr>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"                                     
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(cantSalida)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(montoSubTotal)+"</td>"                                     
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(montoDescuento)+"</td>"                                     
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(montoTotal)+"</td>"                                     
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo bordeDerecho'>"+format.format(montoEsperado)+"</td>"                                     
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