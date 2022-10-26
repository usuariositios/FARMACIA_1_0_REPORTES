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
public double saldoInicial(String codProducto, String fechaSaldoInicial, String codAlmacenVenta) throws Exception {
            Utiles utiles = new Utiles();
            utiles.getConnection();


        String nombreproducto = "";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        double ingresos = 0;
        double salidas = 0;
        try {
            
            String consulta =    " SELECT sum(iad.cant_ingreso)as ingresos_total_anterior "
                        + " FROM ventas.ingresos_venta_detalle iad inner join ventas.ingresos_venta ia "
                        + " on iad.cod_ingreso_venta=ia.cod_ingreso_venta"
                        + " and ia.cod_estado_ingreso_venta=1 "
                        + " and iad.cod_producto='"+codProducto+"' and ia.cod_almacen_venta='"+codAlmacenVenta+"' "
                        + " and ia.fecha_ingreso_venta<='"+fechaSaldoInicial+" 00:00:00' ";

            System.out.println("PresentacionesProducto:sql:" + consulta);
            Statement st = utiles.getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);


            if (rs.next()) {
                ingresos = rs.getDouble("ingresos_total_anterior");
            }
            consulta = " select sum(sad.cant_salida)as salidas_total_anterior "
                        + " from ventas.salidas_venta_detalle sad"
                        + " inner join ventas.salidas_venta s"
                        + " on sad.cod_salida_venta=s.cod_salida_venta"
                        + " and s.cod_estado_salida_venta=1"
                        + " and sad.cod_producto="+codProducto+" and s.cod_almacen_venta='"+codAlmacenVenta+"'"
                        + " and s.fecha_salida_venta<='"+fechaSaldoInicial+" 00:00:00' ";        

            System.out.println("PresentacionesProducto:sql:" + consulta);
            Statement st1 = utiles.getCon().createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs1 = st1.executeQuery(consulta);

            if (rs1.next()) {
                salidas = rs1.getDouble("salidas_total_anterior");
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
        utiles.closeConnection();
        return (ingresos - salidas);

    }    
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
        <title>Reporte de Ingresos a Almacen</title>
        <link href="../css/web.css" rel="stylesheet" type="text/css" />
        
    </head>
    <body>
        
            

                <%
                
                //--------para formato de numeros------------------    
                NumberFormat nf = NumberFormat.getNumberInstance();
                DecimalFormat format = (DecimalFormat)nf;
                format.applyPattern("#,###.00");
                
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                    

                    
                    String fechaInicio=  "01/06/2016"; //request.getParameter("fechaInicio")==null?"0":request.getParameter("fechaInicio");
                    String fechaFinal= "01/10/2017";//request.getParameter("fechaFinal")==null?"0":request.getParameter("fechaFinal");                    
                    //String codMaterial="0";//request.getParameter("codMaterial")==null?"0":request.getParameter("codMaterial");
                    
                    
                    fechaInicio = request.getParameter("fechaInicio");
                    fechaFinal = request.getParameter("fechaFinal");
                    String codProducto = request.getParameter("codProducto");
                    String nombreProducto = request.getParameter("nombreProducto");
                    String codAlmacenVenta = request.getParameter("codAlmacenVenta");
                    String codEmpresa = request.getParameter("codEmpresa");
                    String codGestion = request.getParameter("codGestion");
                    UtilesSesion us = new UtilesSesion();
                    us.getLogotipoEmpresa(Integer.valueOf(codEmpresa));//se carga en una variable estatica
                    
                    
                    
                    
                    System.out.println("codProducto " + codProducto);
                    
                    
                    
                    //double saldo = 0.0;
                    //saldo = this.saldoInicial(codProducto, fechaInicio, codAlmacenVenta);
                    
                    
                 
                 
                 
                 //System.out.println("consulta " + consulta);
                 //Statement st = con.createStatement();
                 //ResultSet rs = st.executeQuery(consulta);
                 
                %>
                <h3 align="center" class="outputText2">REPORTE INGRESOS ALMACEN</h3>
            <br>
            <form>
                <table align="center" width="40%"  style="" class="outputText2" >
                    
                    <tr>
                        <td rowspan="4"  ><img src="data:image/jpg;base64,<%=us.logotipoEmpresa%>" width="200" /></td>
                        <td><b>Producto :</b></td><td><%=nombreProducto%></td>
                    </tr>
                    <tr>
                        <td><b>Fecha Inicio:</b></td><td><%=fechaInicio%></td>
                    </tr>
                    <tr>
                        <td ><b>Fecha Final: </b></td><td><%=fechaFinal%></td>
                    </tr>
                    
                </table><br/><br/>
                
             <%
                     
                 
                     String consulta = "  SELECT	ia.fecha_ingreso_venta,ia.nro_ingreso_venta,oc.nro_orden_compra,td.nombre_campo  nombre_tipo,pr.nombre_proveedor,p.nombre_producto,"
                             + "  pp.nombre_campo nombre_presentacion,ng.nombre_campo nombre_generico,iad.cant_ingreso,u.nombre_unidad_medida"
                             + "  FROM ventas.ingresos_venta ia "
                             + "  inner join ventas.tabla_detalle td ON  td.cod_campo = ia.cod_tipo_ingreso_venta "
                             + "  INNER JOIN ventas.tabla t ON t.cod_tabla   = td.cod_tabla AND     t.nombre_tabla = 'TIPOS_INGRESO_VENTA' "
                             + "  INNER JOIN ventas.ingresos_venta_detalle iad ON ia.cod_ingreso_venta = iad.cod_ingreso_venta"
                             + "  INNER JOIN public.productos p on p.cod_producto = iad.cod_producto"
                             + "  INNER JOIN PUBLIC.unidades_medida u ON u.cod_unidad_medida = iad.cod_unidad_medida "
                             + "  left outer join public.ordenes_compra oc on oc.cod_orden_compra = ia.cod_orden_compra"
                             + "  left outer join public.proveedores pr on pr.cod_proveedor = ia.cod_proveedor"
                             + "  left outer join ( select tdp.* from ventas.tabla_detalle tdp"
                             + "  INNER JOIN ventas.tabla tp ON tdp.cod_tabla = tp.cod_tabla AND tp.nombre_tabla = 'PRESENTACIONES_PRODUCTO' ) pp on pp.cod_campo = p.cod_presentacion                    "
                             + "  left outer join ( select tdn.* from ventas.tabla_detalle tdn"
                             + "  INNER JOIN ventas.tabla tp ON tdn.cod_tabla = tp.cod_tabla AND tp.nombre_tabla = 'NOMBRE_GENERICO' ) ng on ng.cod_campo = p.cod_nombre_generico "
                             + "  WHERE ia.COD_ALMACEN_VENTA = '"+codAlmacenVenta+"' AND ia.COD_GESTION = '"+codGestion+"'  "
                             + "  AND ia.fecha_ingreso_venta >= '"+fechaInicio+" 00:00:00' AND ia.fecha_ingreso_venta <= '"+fechaFinal+" 23:59:59' and ia.cod_estado_ingreso_venta = 1  ";
                     if(!codProducto.equals("0")){
                            consulta +=" and iad.cod_producto in ("+codProducto+") ";
                        }
                     
                     System.out.println("consulta " + consulta);
                     Statement st1 = utiles.getCon().createStatement();
                     ResultSet rs1 = st1.executeQuery(consulta);
                     out.print("<div align=center>"+
                               "<table class='tablaReportes'>");
                     out.print("<tr>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>FECHA</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NRO INGRESO</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>TIPO INGRESO</th>"                                 
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NRO ORDEN COMPRA</th>"                                                                  
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>PROVEEDOR</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>PRODUCTO</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>PRESENTACION</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>NOMBRE GENERICO</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>CANTIDAD</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>UNIDADES</th>"                                 
                                 + "</tr>");
                     
                     
                         while(rs1.next()){
                         
                             out.print("<tr >"
                                     + "<td class='bordeIzquierdo'>"+sdf.format(rs1.getTimestamp("fecha_ingreso_venta"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getInt("nro_ingreso_venta")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_tipo")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nro_orden_compra")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_proveedor")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_producto")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_presentacion")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_generico")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("cant_ingreso"))+"</td>"
                                     + "<td class='bordeIzquierdo bordeDerecho'>"+rs1.getString("nombre_unidad_medida")+"</td>"
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