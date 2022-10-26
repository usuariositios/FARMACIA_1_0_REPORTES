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
        <title>Cuentas por cobrar</title>
        <link href="../css/web.css" rel="stylesheet" type="text/css" />
        
    </head>
    <body>
        
            

                <%
                
                //--------para formato de numeros------------------    
                NumberFormat nf = NumberFormat.getNumberInstance();
                DecimalFormat format = (DecimalFormat)nf;
                format.applyPattern("#,##0.00");
                
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");//HH:mm:ss
                    
                    
                    
                    
                    String fechaFinal = request.getParameter("fechaFinal");//fecha final de pago
                    
                    String codEmpresa = request.getParameter("codEmpresa");
                    String codAlmacenVenta = request.getParameter("codAlmacenVenta");
                    String codGestion = request.getParameter("codGestion");
                    String codCliente = request.getParameter("codCliente");
                    
                    
                    /*codEmpresa = "18";
                    codAlmacenVenta = "1";
                    fechaFinal = "31/08/2020";*/
                    UtilesSesion us = new UtilesSesion();
                    us.getLogotipoEmpresa(Integer.valueOf(codEmpresa));//se carga en una variable estatica
                    
                    //System.out.println("codAnio " + codGestion + " codMes " + codMes);
                    
                    
                 
                %>
                <h3 align="center" class="outputText2">REPORTE CUENTAS POR COBRAR</h3>
            <br>
            <form>
                    <table align="center"  width="40%"  style="" class="outputText2" >
                        <tr>
                            <td rowspan="2" width="140px"  ><img src="<%=us.logotipoEmpresa%>" width="200" /></td>
                            <td><b>Cliente :</b></td><td><%=""%></td>
                        </tr>
                        <tr>
                            <td><b>Tipo de Venta:</b></td><td><%=""%></td>
                        </tr>
                    </table>                
                    <br/><br/>
                
             <%
                     
                 
                     String consulta = " select sv.nro_salida_venta,f.fecha_factura,c.cod_cliente,c.nombre_cliente,c.nit_cliente,sv.monto_sub_total,sv.monto_descuento,"
                             + " sv.monto_total,sv.monto_cancelado,sv.monto_amortizado,sv.monto_por_cobrar,sv.fecha_pago_credito"
                             + " from ventas.salidas_venta sv"
                             + " inner join ventas.facturas_emitidas f on f.cod_salida_venta = sv.cod_salida_venta and f.cod_estado_registro = 1"
                             + " inner join public.clientes c on c.cod_cliente = sv.cod_cliente"
                             + " where sv.cod_gestion="+codGestion+" and sv.venta_completa = 2 and sv.cod_almacen_venta = '"+codAlmacenVenta+"'"
                             + " and f.cod_factura_emitida !=0 and sv.fecha_pago_credito <= '"+fechaFinal+"' ";
                             if(!codCliente.equals("0")){consulta +=" and sv.cod_cliente='"+codCliente+"' ";}
                     
                     
                     System.out.println("consulta " + consulta);
                     Statement st1 = utiles.getCon().createStatement();
                     ResultSet rs1 = st1.executeQuery(consulta);
                     out.print("<div align=center>"+
                               "<table class='tablaReportes'>");
                     out.print("<tr>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NRO <br/> SALIDA <br/> VENTA</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>FECHA</th>"                                 
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NIT CLIENTE</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NOMBRE CLIENTE</th>"                                 
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>MONTO <br/> SUB TOTAL</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>MONTO <br/>DESCUENTO</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>MONTO <br/> TOTAL</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>PAGO INICIAL</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>MONTO AMORTIZADO</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>MONTO POR COBRAR</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>FECHA FIJADA A PAGAR</th>"                                                                  
                                 + "</tr>");
                     
                     
                         while(rs1.next()){
                             
                             out.print("<tr >"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nro_salida_venta")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+(rs1.getTimestamp("fecha_factura")!=null?sdf.format(rs1.getTimestamp("fecha_factura")):"")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nit_cliente")+"</td>"                                     
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_cliente")+"</td>"                                     
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_sub_total"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_descuento"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_total")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_cancelado")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_amortizado")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_por_cobrar")) +"</td>"
                                     + "<td class='bordeIzquierdo bordeDerecho'>"+(rs1.getTimestamp("fecha_pago_credito")!=null?sdf.format(rs1.getTimestamp("fecha_pago_credito")):"") +"</td>"
                                     
                                     + "</tr>");
                                
                         }
                         out.print("<tr>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"                                     
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(0)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(0)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(0)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(0)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(0)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo bordeDerecho'>"+format.format(0)+"</td>"
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