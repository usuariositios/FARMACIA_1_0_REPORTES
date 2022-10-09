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
        <title>Ventas facturadas</title>
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
                    String codPersonal = request.getParameter("codPersonal");
                    String codCliente = request.getParameter("codCliente");
                    String codTipoVenta = request.getParameter("codTipoVenta");
                    String codEmpresa = request.getParameter("codEmpresa");
                    UtilesSesion us = new UtilesSesion();
                    us.getLogotipoEmpresa(Integer.valueOf(codEmpresa));//se carga en una variable estatica
                    
                    //System.out.println("codAnio " + codGestion + " codMes " + codMes);
                    
                    
                 
                %>
                <h3 align="center" class="outputText2">REPORTE VENTAS FACTURADAS</h3>
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
                     
                 
                     String consulta = " SELECT s.nro_salida_venta,f.nro_factura,f.razon_social,f.nit_cliente,f.nro_autorizacion,   f.fecha_factura,"
                             + " f.monto_sub_total,f.monto_descuento,f.monto_total,s.monto_cancelado,s.monto_amortizado,s.monto_por_cobrar,f.codigo_control,   f.cod_dosificacion,e.cod_estado_registro,"
                             + " e.nombre_estado_registro,monto_iva,f.cod_salida_venta,s.fecha_pago_credito,s.cod_personal_venta,s.cod_tipo_venta,tdv.nombre_campo nombre_tipo_venta  "
                             + " FROM   ventas.facturas_emitidas f "
                             + " inner join ventas.salidas_venta s on s.cod_salida_venta = f.cod_salida_venta"
                             + " inner join ventas.almacenes_venta av on av.cod_almacen_venta = s.cod_almacen_venta "
                             + " inner join ventas.sucursal_ventas sv on sv.cod_sucursal = av.cod_sucursal_venta "
                             + " inner join public.empresa em on em.cod_empresa = sv.cod_empresa "
                             + " inner join ventas.tabla_detalle tdv ON  tdv.cod_campo = s.cod_tipo_venta"
                             + " INNER JOIN ventas.tabla ts ON tdv.cod_tabla   = ts.cod_tabla AND     ts.nombre_tabla = 'TIPOS_VENTA'"
                             + " inner join public.estados_registro e   on e.cod_estado_registro = f.cod_estado_registro"
                             + " where 0=0 and f.fecha_factura between '"+fechaInicio+"' and '"+fechaFinal+"' and em.cod_empresa='"+codEmpresa+"'";
                             
                     if(!codTipoVenta.equals("0")){consulta+=" and s.cod_tipo_venta='"+codTipoVenta+"' ";}
                     if(!codCliente.equals("0")){consulta+=" and s.cod_cliente = '"+codCliente+"' ";}
                     
                     System.out.println("consulta " + consulta);
                     Statement st1 = utiles.getCon().createStatement();
                     ResultSet rs1 = st1.executeQuery(consulta);
                     out.print("<div align=center>"+
                               "<table class='tablaReportes'>");
                     out.print("<tr>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NRO <br/> SALIDA <br/> VENTA</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NRO FACTURA</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NRO AUT</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NIT CLIENTE</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NOMBRE CLIENTE</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>FECHA FACTURA</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>MONTO <br/> SUB TOTAL</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>MONTO <br/>DESCUENTO</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>MONTO <br/> TOTAL</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>PAGO INICIAL</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>MONTO AMORTIZADO</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>MONTO POR COBRAR</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>FECHA FIJADA A PAGAR</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>TIPO VENTA</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>PERSONAL <br/> ENCARGADO</th>"
                                 + "</tr>");
                     
                     
                         while(rs1.next()){
                             
                             out.print("<tr >"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nro_salida_venta")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nro_factura")+"</td>"                                     
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nro_autorizacion")+"</td>"                                     
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nit_cliente")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("razon_social")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+(rs1.getTimestamp("fecha_factura")!=null?sdf.format(rs1.getTimestamp("fecha_factura")):"")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_sub_total"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_descuento"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_total")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_cancelado")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_amortizado")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_por_cobrar")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+(rs1.getTimestamp("fecha_pago_credito")!=null?sdf.format(rs1.getTimestamp("fecha_pago_credito")):"") +"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_tipo_venta") +"</td>"                                     
                                     + "<td class='bordeIzquierdo bordeDerecho'>"+rs1.getString("cod_personal_venta") +"</td>"                                     
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
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(0)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(0)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(0)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo bordeDerecho'>"+format.format(0)+"</td>"
                                     + "<td class='bordeArriba'></td>"
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