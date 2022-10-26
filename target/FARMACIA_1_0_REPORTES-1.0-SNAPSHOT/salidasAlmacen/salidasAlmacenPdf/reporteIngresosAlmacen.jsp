<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="com.cofar.bean.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "java.sql.*"%> 
<%@ page import = "java.text.SimpleDateFormat"%> 
<%@ page import = "java.util.ArrayList"%> 
<%@ page import = "java.util.Date"%> 
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%> 
<%@ page import = "java.text.NumberFormat"%> 
<%@ page import = "java.util.Locale"%> 

<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%! Connection con=null;


%>
<%! public String nombrePresentacion1(String codPresentacion){
    

 
String  nombreproducto="";

try{
con=Util.openConnection(con);
String sql_aux="select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='"+codPresentacion+"'";
System.out.println("PresentacionesProducto:sql:"+sql_aux);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql_aux);
while (rs.next()){
String codigo=rs.getString(1);
nombreproducto=rs.getString(2);
}
} catch (SQLException e) {
e.printStackTrace();
    }
    return "";
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        
        <%--meta http-equiv="Content-Type" content="text/html; charset=UTF-8"--%>
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
    </head>
    <body>
        <h3 align="center">INGRESO A ALMACEN</h3>
        <br>
        <form>
            <div align="center">
            
                <%
                try{
                
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,###");
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                IngresosAlmacen ingresosAlmacen = (IngresosAlmacen)request.getSession().getAttribute("ingresosAlmacen");

                    String codOrdenCompra=request.getParameter("codOrdenCompra")==null?"0":request.getParameter("codOrdenCompra");
                    String codIngresoAlmacen=request.getParameter("codIngresoAlmacen")==null?"0":request.getParameter("codIngresoAlmacen");

                    //codOrdenCompra = "10069";

                    String consulta = " select i.COD_INGRESO_ALMACEN,i.NRO_INGRESO_ALMACEN,i.COD_PROVEEDOR,p.NOMBRE_PROVEEDOR,i.FECHA_INGRESO_ALMACEN," +
                            " i.NRO_DOCUMENTO, oc.NRO_ORDEN_COMPRA,t.NOMBRE_TIPO_INGRESO_ALMACEN,tc.NOMBRE_TIPO_COMPRA,oc.NRO_ORDEN_COMPRA " +
                            "      from INGRESOS_ALMACEN i " +
                            " left outer join  PROVEEDORES p on p.COD_PROVEEDOR = i.COD_PROVEEDOR " +
                            " left outer join TIPOS_INGRESO_ALMACEN t on t.COD_TIPO_INGRESO_ALMACEN = i.COD_TIPO_INGRESO_ALMACEN " +
                            " left outer join TIPOS_COMPRA tc on i.COD_TIPO_COMPRA = tc.COD_TIPO_COMPRA " +
                            " left outer join ORDENES_COMPRA oc on oc.COD_ORDEN_COMPRA = i.COD_ORDEN_COMPRA " +
                            " where i.COD_INGRESO_ALMACEN = '"+ingresosAlmacen.getCodIngresoAlmacen()+"' ";
                System.out.println("consulta"+consulta);
                con = Util.openConnection(con);
                Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1=st1.executeQuery(consulta);
                
                consulta = " select gr.nombre_grupo from grupos gr where gr.cod_grupo in (select m.cod_grupo from ingresos_almacen_detalle iad inner join materiales m on m.cod_material = iad.cod_material where iad.cod_ingreso_almacen = '"+ingresosAlmacen.getCodIngresoAlmacen()+"') ";
                System.out.println("consulta"+consulta);
                con = Util.openConnection(con);
                Statement st3=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs3=st3.executeQuery(consulta);
                String nombreGrupo = "";
                while(rs3.next()){
                    nombreGrupo = nombreGrupo+","+rs3.getString("NOMBRE_GRUPO");
                }
                nombreGrupo = nombreGrupo.substring(1,nombreGrupo.length());
                if(rs1.next()){
                    out.print(" <table border='0' style='text-align:left' class='outputText1'> ");
                    out.print(" <tr><td rowspan='4'><img src='../img/cofar.png' /></td><td><b> Nro Ingreso : </b></td> <td> "+(rs1.getString("NRO_INGRESO_ALMACEN")==null?"":rs1.getString("NRO_INGRESO_ALMACEN"))+" </td><td><b>Proveedor: </b></td> <td> "+(rs1.getString("NOMBRE_PROVEEDOR")==null?"":rs1.getString("NOMBRE_PROVEEDOR"))+" </td> </tr>");
                    out.print(" <tr><td><b>Fecha: </b></td><td> "+(rs1.getDate("FECHA_INGRESO_ALMACEN")==null?"":sdf.format(rs1.getDate("FECHA_INGRESO_ALMACEN")))+" </td> <td><b>Factura Nro.:</b></td> <td>"+(rs1.getString("NRO_DOCUMENTO")==null?"":rs1.getString("NRO_DOCUMENTO"))+"</td> </tr>");
                    out.print(" <tr><td><b>Tipo de Ingreso: </b></td> <td>"+(rs1.getString("NOMBRE_TIPO_INGRESO_ALMACEN")==null?"":rs1.getString("NOMBRE_TIPO_INGRESO_ALMACEN"))+"</td> <td><b> Tipo de Compra: </b></td> <td>"+(rs1.getString("NOMBRE_TIPO_COMPRA")==null?"":rs1.getString("NOMBRE_TIPO_COMPRA"))+"</td> </tr>");
                    out.print(" <tr><td><b>Grupo:</b></td><td>"+nombreGrupo+"</td> <td><b>Nro. O.C.</b></td> <td>"+(rs1.getString("NRO_ORDEN_COMPRA")==null?"":rs1.getString("NRO_ORDEN_COMPRA"))+"</td> </tr> ");
                    out.print(" </table> ");
                }

                // detalle

                 consulta = " select m.CODIGO_ANTIGUO,m.NOMBRE_MATERIAL,iad.CANT_TOTAL_INGRESO,iad.CANT_TOTAL_INGRESO_FISICO,u.NOMBRE_UNIDAD_MEDIDA,u.ABREVIATURA,(select sum(iade.tara) from ingresos_almacen_detalle_estado iade where iade.cod_ingreso_almacen = iad.cod_ingreso_almacen and iade.cod_material = iad.cod_material) tara " +
                         " from INGRESOS_ALMACEN_DETALLE iad inner join MATERIALES m on m.COD_MATERIAL = iad.COD_MATERIAL " +
                         " inner join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = iad.COD_UNIDAD_MEDIDA " +
                         " where iad.COD_INGRESO_ALMACEN = '"+ingresosAlmacen.getCodIngresoAlmacen()+"' ";

                 System.out.println("consulta " + consulta);

                Statement st2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs2=st2.executeQuery(consulta);

                out.print(" <table style='border : solid #f2f2f2 1px;' class='outputText2' width='70%' cellpadding='0' cellspacing='0' > ");
                out.print(" <tr class='tablaFiltroReporte'><td class='bordeNegroTd'> Codigo </td> <td class='bordeNegroTd'> Item </td> " +
                            " <td class='bordeNegroTd'> Cantidad </td> <td class='bordeNegroTd'> Unid. </td><td class='bordeNegroTd'>Tara</td></tr>");
                while(rs2.next()){

                    out.print(" <tr  ><td class='bordeNegroTd'> "+(rs2.getString("CODIGO_ANTIGUO")==null?"":rs2.getString("CODIGO_ANTIGUO"))+" </td> <td class='bordeNegroTd'> "+(rs2.getString("NOMBRE_MATERIAL")==null?"":rs2.getString("NOMBRE_MATERIAL"))+" </td> " +
                            " <td class='bordeNegroTd'> "+(rs2.getString("CANT_TOTAL_INGRESO_FISICO")==null?"":rs2.getString("CANT_TOTAL_INGRESO_FISICO"))+" </td> <td class='bordeNegroTd'> "+(rs2.getString("ABREVIATURA")==null?"":rs2.getString("ABREVIATURA"))+" </td>" +
                            "<td class='bordeNegroTd'>"+rs2.getDouble("TARA")+"</td></tr>");
                }
                out.print(" </table> ");
                 

                 




                %>                
            

            <br/>
            <table width="70%" align="center" style="text-align:left">
            <tr><td><b>
                Glosa:
                </b>
            </td>
            <td><%out.print(ingresosAlmacen.getObsIngresoAlmacen()==null?"":ingresosAlmacen.getObsIngresoAlmacen());
            }catch(Exception e){e.printStackTrace(); }
            %></td>
            </tr>
            </table>

            <br>
            <br>
            <br>
                <br/><br/><br/><br/><br/>

            <table style="text-align:center" align="center" width="70%">
                <tr><td style="border-bottom-color:black;border-bottom-style:solid;border-bottom-width:thin;border-right-width:20px;border-right-color:white;border-right-style:solid" width="33%"></td>
                <td style="border-bottom-color:black;border-bottom-style:solid;border-bottom-width:thin;border-right-width:20px;border-right-color:white;border-right-style:solid" width="33%"> </td>
                <td style="border-bottom-color:black;border-bottom-style:solid;border-bottom-width:thin" width="33%"> </td></tr>
                <tr><td>Aprobado</td><td>Entregado <br/> Nombre y Firma</td><td>Recibido<br/> Nombre y Firma</td></tr>
            </table>
            
            <table style="background:#BBFFCC;text-align:left " ></table>
            </div>
            
            
        </form>
    </body>
</html>