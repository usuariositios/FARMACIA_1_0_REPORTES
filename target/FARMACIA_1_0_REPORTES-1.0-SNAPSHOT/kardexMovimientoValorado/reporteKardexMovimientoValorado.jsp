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
        <title>Reporte kardex movimiento valorado</title>
        <link href="../css/web.css" rel="stylesheet" type="text/css" />
        
    </head>
    <body>
        
            

                <%
                
                //--------para formato de numeros------------------    
                NumberFormat nf = NumberFormat.getNumberInstance();
                DecimalFormat format = (DecimalFormat)nf;
                format.applyPattern("#,##0.00");
                
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
                    
                    /*codEmpresa = "18";
                    fechaInicio=  "01/06/2016";
                    fechaFinal= "01/10/2020";
                    codProducto = "31";
                    codAlmacenVenta = "10";*/
                    
                    UtilesSesion us = new UtilesSesion();
                    
                    us.getLogotipoEmpresa(Integer.valueOf(codEmpresa));//se carga en una variable estatica
                    
                    
                    
                    
                    
                    
                    System.out.println("codProducto " + codProducto);
                    
                    
                    
                    double saldo = 0.0;
                    saldo = this.saldoInicial(codProducto, fechaInicio, codAlmacenVenta);
                    
                    double precioUnitarioIngreso =0.0;
                    double precioTotalIngreso = 0.0;
                    double precioUnitarioSalida = 0.0;
                    
                    double precioTotalSalida = 0.0;
                    double precioUnitarioSaldo = 0.0;
                    double precioTotalSaldo = 0.0;
                    
                    double cantidadSaldo = 0.0;
                    double precionUnitarioSaldoAnt = 0.0;
                    double precioTotalSaldoAnt = 0.0;
                    double cantidadSaldoAnt = 0.0;
                    
                    
                    
                    
                 //System.out.println("consulta " + consulta);
                 //Statement st = con.createStatement();
                 //ResultSet rs = st.executeQuery(consulta);
                 
                %>
                <h3 align="center" class="outputText2">REPORTE KARDEX DE MOVIMIENTO VALORADO</h3>
            <br>
            <form>
                <table align="center" width="40%"  style="" class="outputText2" >
                    
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
                     
                 
                     String consulta = "SELECT * FROM(		"
                             + " SELECT	ia.fecha_ingreso_venta fecha,	'Ingreso' transac,td.cod_campo tipo,td.nombre_campo  nombre_tipo,"
                             + " ia.nro_ingreso_venta nro,iad.cant_ingreso,0 cant_salida,u.abreviatura,iad.total_monto monto_valorado"
                             + " FROM ventas.ingresos_venta ia "
                             + " inner join ventas.tabla_detalle td ON  td.cod_campo = ia.cod_tipo_ingreso_venta "
                             + " INNER JOIN ventas.tabla t ON t.cod_tabla   = td.cod_tabla AND     t.nombre_tabla = 'TIPOS_INGRESO_VENTA' "
                             + " INNER JOIN ventas.ingresos_venta_detalle iad ON ia.cod_ingreso_venta = iad.cod_ingreso_venta"
                             + " INNER JOIN PUBLIC.unidades_medida u ON u.cod_unidad_medida = iad.cod_unidad_medida"
                             + " WHERE"
                             + " iad.cod_producto IN ("+codProducto+") AND ia.cod_almacen_venta = '"+codAlmacenVenta+"'	AND ia.fecha_ingreso_venta >= '"+fechaInicio+" 00:00:00' AND ia.fecha_ingreso_venta <= '"+fechaFinal+" 23:59:59'"
                             + " UNION ALL"
                             + " SELECT s.fecha_salida_venta,	'Salida', td.cod_campo,	td.nombre_campo, s.nro_salida_venta,0,	sd.cant_salida,	u.abreviatura,sd.monto_total"
                             + " FROM ventas.salidas_venta s"
                             + " INNER JOIN ventas.salidas_venta_detalle sd ON s.cod_salida_venta = sd.cod_salida_venta"
                             + " inner join ventas.tabla_detalle td ON  td.cod_campo = s.cod_tipo_salida_venta "
                             + " INNER JOIN ventas.tabla t ON t.cod_tabla   = td.cod_tabla AND     t.nombre_tabla = 'TIPOS_SALIDA_VENTA' "
                             + " INNER JOIN PUBLIC.unidades_medida u ON u.cod_unidad_medida = sd.cod_unidad_medida"
                             + " WHERE 	sd.cod_producto IN ("+codProducto+") AND s.cod_almacen_venta = '"+codAlmacenVenta+"' AND s.fecha_salida_venta >= '"+fechaInicio+" 00:00:00' AND s.fecha_salida_venta <= '"+fechaFinal+" 23:59:59'"
                             + ") tb ORDER BY	tb.fecha  ";
                     
                     
                     consulta = "SELECT * FROM("
                             + " SELECT	ia.fecha_ingreso_venta fecha,	'Ingreso' transac,td.cod_campo tipo,td.nombre_campo  nombre_tipo,"
                             + " ia.nro_ingreso_venta nro,iad.cant_ingreso,iad.precio_unitario precio_unitario_ingreso,iad.cant_ingreso*iad.precio_unitario precio_total_ingreso,0 cant_salida,0 precio_unitario_salida,0 precio_total_salida,u.abreviatura"
                             + " FROM ventas.ingresos_venta ia"
                             + " inner join ventas.tabla_detalle td ON  td.cod_campo = ia.cod_tipo_ingreso_venta"
                             + " INNER JOIN ventas.tabla t ON t.cod_tabla   = td.cod_tabla AND     t.nombre_tabla = 'TIPOS_INGRESO_VENTA'"
                             + " INNER JOIN ventas.ingresos_venta_detalle iad ON ia.cod_ingreso_venta = iad.cod_ingreso_venta"
                             + " INNER JOIN PUBLIC.unidades_medida u ON u.cod_unidad_medida = iad.cod_unidad_medida"
                             + " WHERE iad.cod_producto IN ("+codProducto+") AND ia.cod_almacen_venta = '"+codAlmacenVenta+"'"
                             + " AND ia.fecha_ingreso_venta >= '"+fechaInicio+" 00:00:00' AND ia.fecha_ingreso_venta <= '"+fechaFinal+" 23:59:59' and ia.cod_estado_ingreso_venta = 1 "
                             + " UNION ALL"
                             + " SELECT s.fecha_salida_venta,	'Salida', td.cod_campo,	td.nombre_campo, s.nro_salida_venta,0,0,0,sd.cant_salida,0,sd.costo_unitario,"
                             + " u.abreviatura"
                             + " FROM ventas.salidas_venta s"
                             + " INNER JOIN ventas.salidas_venta_detalle sd ON s.cod_salida_venta = sd.cod_salida_venta"
                             + " inner join ventas.tabla_detalle td ON  td.cod_campo = s.cod_tipo_salida_venta"
                             + " INNER JOIN ventas.tabla t ON t.cod_tabla   = td.cod_tabla AND     t.nombre_tabla = 'TIPOS_SALIDA_VENTA'"
                             + " INNER JOIN PUBLIC.unidades_medida u ON u.cod_unidad_medida = sd.cod_unidad_medida"
                             + " WHERE 	sd.cod_producto IN ("+codProducto+") AND s.cod_almacen_venta = '"+codAlmacenVenta+"'"
                             + " AND s.fecha_salida_venta >= '"+fechaInicio+" 00:00:00' AND s.fecha_salida_venta <= '"+fechaFinal+" 23:59:59' and s.cod_estado_salida_venta = 1 ) tb"
                             + " ORDER BY tb.fecha";
                             
                     System.out.println("consulta " + consulta);
                     Statement st1 = utiles.getCon().createStatement();
                     ResultSet rs1 = st1.executeQuery(consulta);
                     out.print("<div align=center>"+
                               "<table class='tablaReportes'>");
                     out.print(
                             "<tr>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>FECHA</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>TRANSACCION</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>TIPO I/S</th>"                                 
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>NRO</th>"                                 
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo'>FACTURA</th>"                                 
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>ENTRADA</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>P.U.</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>P.T.</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>SALIDA</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>P.U.</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>P.T.</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>SALDO</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo'>P.U.</th>"
                                 + "<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho'>P.T.</th>"
                                 
                                 + "</tr>");
                     
                     
                         while(rs1.next()){
                             
                             if(rs1.getDouble("cant_ingreso")!=0 || rs1.getDouble("cant_salida")!=0){                                 
                                 cantidadSaldo+=rs1.getDouble("cant_ingreso") - rs1.getDouble("cant_salida");
                                 if(rs1.getDouble("cant_ingreso")>0){
                                    precioUnitarioSaldo = (precioTotalSaldoAnt + rs1.getDouble("precio_total_ingreso"))/cantidadSaldo;
                                    
                                 }else{
                                    precioUnitarioSaldo = precionUnitarioSaldoAnt;//para salida
                                    precioUnitarioSalida = precionUnitarioSaldoAnt;
                                    precioTotalSalida = precioUnitarioSalida*rs1.getDouble("cant_salida");
                                 }
                                 precioTotalSaldo = cantidadSaldo*precioUnitarioSaldo;                                 
                             }else{
                             }
                             
                             saldo += rs1.getDouble("cant_ingreso") - rs1.getDouble("cant_salida");
                             
                             out.print("<tr >"
                                     + "<td class='bordeIzquierdo'>"+sdf.format(rs1.getTimestamp("fecha"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("transac")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getString("nombre_tipo")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+rs1.getInt("nro")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+0+"</td>"
                                             
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("cant_ingreso"))+" " + rs1.getString("abreviatura")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("precio_unitario_ingreso"))+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("precio_total_ingreso"))+"</td>"
                                             
                                     + "<td class='bordeIzquierdo'>"+format.format(rs1.getDouble("cant_salida"))+" " + rs1.getString("abreviatura")+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(precioUnitarioSalida)+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(precioTotalSalida)+"</td>"
                                             
                                     + "<td class='bordeIzquierdo'>"+format.format(cantidadSaldo)+"</td>"
                                     + "<td class='bordeIzquierdo'>"+format.format(precioUnitarioSaldo)+"</td>"
                                     + "<td class='bordeIzquierdo bordeDerecho'>"+format.format(precioTotalSaldo)+"</td>"
                                             
                                     
                                     + "</tr>");
                             precioTotalSaldoAnt = precioTotalSaldo;
                             precionUnitarioSaldoAnt = precioUnitarioSaldo;
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
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba'></td>"
                                     + "<td class='bordeArriba bordeDerecho'></td>"
                                     
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