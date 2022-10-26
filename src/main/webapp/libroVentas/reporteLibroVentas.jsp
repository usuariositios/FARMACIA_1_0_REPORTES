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
        <title>Reporte libro de ventas</title>
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
                    
                    Double importeTotalVenta =0.0;
                    Double importeIceIehdTasas =0.0;
                    Double expOpExentas = 0.0;
                    Double ventasGravTasaCero = 0.0;
                    Double subTotal = 0.0;
                    Double dctosBonif = 0.0;
                    Double importeBaseDF = 0.0;
                    Double debitoFiscal = 0.0;
                    int numFactura = 1;
                    
                    System.out.println("codAnio " + codGestion + " codMes " + codMes);
                    
                    
                 
                %>
                <h3 align="center" class="outputText2">REPORTE LIBRO DE VENTAS</h3>
            <br>
            <form>
                <table align="center" width="40%"  style="" class="outputText2" >
                    
                    <tr>
                        <td rowspan="4"  ><img src="<%=us.logotipoEmpresa%>" width="200" /></td>
                        <td><b>Gestion :</b></td><td><%=nombreGestion%></td>
                    </tr>
                    <tr>
                        <td><b>Mes:</b></td><td><%=nombreMes%></td>
                    </tr>
                </table><br/><br/>
                
             <%
                     
                 
                     String consulta = " SELECT l.fecha_libro,p.nit_proveedor,p.nombre_proveedor,l.nro_factura,l.nro_DUI,l.nro_autorizacion,l.total_factura,l.importe_no_sujeto_credito_fiscal,"
                             + " l.importe_sub_total,l.descuentos_bonificaciones,l.importe_base_credito_fiscal,l.credito_fiscal,l.codigo_control,t.cod_tipo_documento_libro_compras"
                             + " FROM "
                             + " cont.libro_compras l"
                             + " left outer join cont.comprobante c on c.cod_comprobante = l.cod_comprobante and l.cod_gestion = c.cod_gestion"
                             + " left outer join public.proveedores p on p.cod_proveedor = l.cod_proveedor"
                             + " left outer join cont.tipos_documento_libro_compras t on t.cod_tipo_documento_libro_compras = l.cod_tipo_documento_libro_compras "
                             + " cross join public.gestiones g"
                             + " where g.cod_gestion = '"+codGestion+"' and l.fecha_libro between g.fecha_inicio and g.fecha_final"
                             + " and extract(month from l.fecha_libro)='"+codMes+"' ";
                     
                     consulta = " SELECT l.cod_libro_ventas,l.especificacion,l.numero,l.fecha_factura,l.nro_factura,  l.nro_autorizacion,  l.cod_estado,"
                             + "   c.cod_cliente,  c.nit_cliente,  c.nombre_cliente,  l.monto_total,  l.monto_ice_iehd_tasas,  l.monto_export_operac,"
                             + "   l.monto_vtas_grv_tasa_cero,  l.monto_subtotal,  l.monto_dctos_bonific,  l.importe_base_credito_fiscal,  l.debito_fiscal,"
                             + "   l.codigo_control, l.cod_comprobante,  l.cod_gestion"
                             + " FROM  cont.libro_ventas l"
                             + " inner join public.clientes c on c.cod_cliente = l.cod_cliente"
                             + " inner join ventas.salidas_venta s on s.cod_libro_ventas= l.cod_libro_ventas "
                             + " inner join ventas.almacenes_venta av on av.cod_almacen_venta = s.cod_almacen_venta"
                             + " inner join ventas.sucursal_ventas sv on sv.cod_sucursal = av.cod_sucursal_venta"
                             + " inner join public.empresa e on e.cod_empresa = sv.cod_empresa "
                             + " cross join public.gestiones g "
                             + " where g.cod_gestion = '"+codGestion+"' and l.fecha_factura between g.fecha_inicio and g.fecha_final"
                             + " and extract(month from l.fecha_factura)='"+codMes+"' and e.cod_empresa = '"+codEmpresa+"' ";
                     
                     System.out.println("consulta " + consulta);
                     Statement st1 = utiles.getCon().createStatement();
                     ResultSet rs1 = st1.executeQuery(consulta);
                     out.print("<div align=center>"+
                               "<table class='tablaReportes'>");
                     out.print("<tr>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>ESPECI-<br/>FICACION</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NRO</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>FECHA DE LA FACTURA</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NRO DE LA FACTURA</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NRO DE AUT.</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>ESTADO</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NIT/CI CLIENTE</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>NOMBRE O RAZON SOCIAL</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>IMPORTE<br/> TOTAL<br/> DE VENTA</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>IMPORTE<br/> ICE/ IEHD/<br/> TASAS</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>EXPORT.<br/> Y OPERAC.<br/> EXENTAS</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>VENTAS GRAVADAS <br/> A TASA<br/> CERO</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>SUBTOTAL</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>DCTOS,<br/> BONIF Y<br/> REBAJAS<br/> OTORGADAS</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>IMPORTE<br/> BASE PARA<br/> DEBITO<br/> FISCAL</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>DEBITO FISCAL</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>CODIGO DE CONTROL</th>"
                                 + "</tr>");
                     
                     
                         while(rs1.next()){
                             
                             out.print("<tr >"
                                     + "<td class='bordeIzquierdo'>"+rs1.getInt("especificacion")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+numFactura+"</td>"//rs1.getInt("numero")
                                     + "<td class='bordeIzquierdo'>"+sdf.format(rs1.getTimestamp("fecha_factura"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nro_factura")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nro_autorizacion")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("cod_estado")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nit_cliente")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_cliente")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_total"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_ice_iehd_tasas"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_export_operac")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_vtas_grv_tasa_cero")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_subtotal")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("monto_dctos_bonific")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("importe_base_credito_fiscal")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("debito_fiscal")) +"</td>"
                                     + "<td class='bordeIzquierdo bordeDerecho'>"+rs1.getString("codigo_control") +"</td>"                                     
                                     + "</tr>");
                                importeTotalVenta +=rs1.getDouble("monto_total");
                                importeIceIehdTasas +=rs1.getDouble("monto_ice_iehd_tasas");
                                expOpExentas += rs1.getDouble("monto_export_operac");
                                ventasGravTasaCero += rs1.getDouble("monto_vtas_grv_tasa_cero");
                                subTotal += rs1.getDouble("monto_subtotal");
                                dctosBonif += rs1.getDouble("monto_dctos_bonific");
                                importeBaseDF += rs1.getDouble("importe_base_credito_fiscal");
                                debitoFiscal += rs1.getDouble("debito_fiscal");
                                numFactura++;
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
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(importeTotalVenta)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(importeIceIehdTasas)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(expOpExentas)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(ventasGravTasaCero)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(subTotal)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(dctosBonif)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(importeBaseDF)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo bordeDerecho'>"+format.format(debitoFiscal)+"</td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "</tr>");
                         out.print("</table></div>");
                     
                     
                     
                     //con.close();
                     
                     
                 
                }catch(Exception e){
                    e.printStackTrace();
                }
                utiles.closeConnection();
             %>
             
            
            
            
        </form>
    </body>
</html>