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
        <title>Reporte libro de compras</title>
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

                    Double importeTotalCompra =0.0;
                    Double importeNoSujCF = 0.0;
                    Double subTotal = 0.0;
                    Double descBonif = 0.0;
                    Double importeBaseCF = 0.0;
                    Double creditoFiscal = 0.0;
                    
                    
                    
                    System.out.println("codAnio " + codGestion + " codMes " + codMes);
                    
                    
                 
                %>
                <h3 align="center" class="outputText2">REPORTE LIBRO DE COMPRAS</h3>
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
                             
                             + " inner join ventas.ingresos_venta i on i.cod_libro_compras = l.cod_libro_compras"
                             + " inner join ventas.almacenes_venta av on av.cod_almacen_venta = i.cod_almacen_venta"
                             + " inner join ventas.sucursal_ventas sv on sv.cod_sucursal = av.cod_sucursal_venta"
                             + " inner join public.empresa em on em.cod_empresa = sv.cod_empresa "
                             
                             + " left outer join cont.comprobante c on c.cod_comprobante = l.cod_comprobante and l.cod_gestion = c.cod_gestion"
                             + " left outer join public.proveedores p on p.cod_proveedor = l.cod_proveedor"
                             + " left outer join cont.tipos_documento_libro_compras t on t.cod_tipo_documento_libro_compras = l.cod_tipo_documento_libro_compras "
                             + " cross join public.gestiones g"
                             + " where g.cod_gestion = '"+codGestion+"' and l.fecha_libro between g.fecha_inicio and g.fecha_final"
                             + " and extract(month from l.fecha_libro)='"+codMes+"' "
                             + " and em.cod_empresa = '"+codEmpresa+"' ";
                     
                     consulta = " SELECT l.fecha_libro,p.nit_proveedor,p.nombre_proveedor,l.nro_factura,l.nro_DUI,l.nro_autorizacion,l.total_factura,l.importe_no_sujeto_credito_fiscal,"
                             + " l.importe_sub_total,l.descuentos_bonificaciones,l.importe_base_credito_fiscal,l.credito_fiscal,l.codigo_control,t.cod_tipo_documento_libro_compras"
                             + " FROM  cont.libro_compras l "
                             + " inner join ventas.ingresos_venta i on i.cod_libro_compras = l.cod_libro_compras "
                             + " inner join ventas.almacenes_venta av on av.cod_almacen_venta = i.cod_almacen_venta "
                             + " inner join ventas.sucursal_ventas sv on sv.cod_sucursal = av.cod_sucursal_venta "
                             + " inner join public.empresa em on em.cod_empresa = sv.cod_empresa  "
                             + " inner join public.gestiones g on g.cod_gestion = l.cod_gestion"
                             + " left outer join cont.comprobante c on c.cod_comprobante = l.cod_comprobante and l.cod_gestion = c.cod_gestion "
                             + " left outer join public.proveedores p on p.cod_proveedor = l.cod_proveedor"
                             + " left outer join cont.tipos_documento_libro_compras t on t.cod_tipo_documento_libro_compras = l.cod_tipo_documento_libro_compras"
                             + " where g.cod_gestion = '"+codGestion+"' "
                             + " and em.cod_empresa = '"+codEmpresa+"' "
                             + " order by l.cod_libro_compras desc ";
                     
                     
                     System.out.println("consulta " + consulta);
                     Statement st1 = utiles.getCon().createStatement();
                     ResultSet rs1 = st1.executeQuery(consulta);
                     out.print("<div align=center>"+
                               "<table class='tablaReportes'>");
                     out.print("<tr>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>FECHA DE LA FACTURA O DUI</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NIT PROVEEDOR</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NOMBRE Y APELLIDO/RAZON SOCIAL</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NRO DE FACTURA</th>"                                 
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NRO DE DUI</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>NRO DE AUTORIZACION</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>IMPORTE TOTAL DE LA COMPRA</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>IMPORTE NO SUJETO A CREDITO FISCAL</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>SUBTOTAL</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>DESCUENTOS, BONIFICACIONES <br>Y REBAJAS OBTENIDAS</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>IMPORTE BASE PARA CREDITO FISCAL</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>CREDITO FISCAL</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>CODIGO DE CONTROL</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>TIPO DE COMPRA</th>"
                                 + "</tr>");
                     
                     
                         while(rs1.next()){
                             
                             out.print("<tr >"
                                     + "<td class='bordeIzquierdo'>"+sdf.format(rs1.getTimestamp("fecha_libro"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nit_proveedor")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_proveedor")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nro_factura")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nro_DUI")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nro_autorizacion")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("total_factura"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("importe_no_sujeto_credito_fiscal"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("importe_sub_total")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("descuentos_bonificaciones")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("importe_base_credito_fiscal")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("credito_fiscal")) +"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("codigo_control") +"</td>"
                                     + "<td class='bordeIzquierdo bordeDerecho'>"+rs1.getString("cod_tipo_documento_libro_compras") +"</td>"
                                     + "</tr>");
                            
                            importeTotalCompra += rs1.getDouble("total_factura");                                                        
                            importeNoSujCF += rs1.getDouble("importe_no_sujeto_credito_fiscal");
                            subTotal +=rs1.getDouble("importe_sub_total");
                            descBonif +=rs1.getDouble("descuentos_bonificaciones");
                            importeBaseCF += rs1.getDouble("importe_base_credito_fiscal");
                            creditoFiscal += rs1.getDouble("credito_fiscal");
                         }
                         out.print("<tr>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(importeTotalCompra)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(importeNoSujCF)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(subTotal)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(descBonif)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo'>"+format.format(importeBaseCF)+"</td>"
                                     + "<td class='bordeArriba bordeAbajo bordeIzquierdo bordeDerecho'>"+format.format(creditoFiscal)+"</td>"
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