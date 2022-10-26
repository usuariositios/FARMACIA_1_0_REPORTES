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
<%@ page contentType="text/html; charset=UTF-8" %>
<html>
    <head>
        
        <%--meta http-equiv="Content-Type" content="text/html; charset=UTF-8"--%>
        <title>Reporte producto</title>
        <link href="../css/web.css" rel="stylesheet" type="text/css" />
        
    </head>
    <body>
        
            

                <%
                
                //--------para formato de numeros------------------    
                NumberFormat nf = NumberFormat.getNumberInstance();
                DecimalFormat format = (DecimalFormat)nf;
                format.applyPattern("#,###.00");
                
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
                    

                    
                    
                    
                    
                    
                    String codProducto = request.getParameter("codProducto");
                    String nombreProducto = request.getParameter("nombreProducto");
                    System.out.println("codProducto " + codProducto);
                    String codEmpresa = request.getParameter("codEmpresa");
                    UtilesSesion us = new UtilesSesion();
                    us.getLogotipoEmpresa(Integer.valueOf(codEmpresa));//se carga en una variable estatica
                 
                %>
                <h3 align="center" class="outputText2">REPORTE DE PRODUCTO</h3>
            <br>
            <form>
                <table align="center" width="40%"  style="" class="outputText2" >
                    
                    <tr>
                        <td rowspan="4"  ><img src="<%=us.logotipoEmpresa%>" width="200" /></td>
                        <td><b>Producto :</b></td><td><%=nombreProducto%></td>
                    </tr>
                    
                </table><br/><br/>
                
             <%
                     
                 
                     String consulta = " SELECT p.cod_producto,p.codigo_producto,p.nombre_producto,p.descripcion_producto,p.cod_grupo_producto,g.nombre_grupo_producto,p.impuesto_producto, " +
                            " p.cod_proveedor1,pr1.nombre_proveedor nombre_proveedor1,p.cod_proveedor2,pr2.nombre_proveedor nombre_proveedor2,p.descripcion_corta_producto,p.stock_minimo,p.stock_maximo,p.aviso_stock_minimo, " +
                            " p.fecha_registro,p.cod_empaque_externo,e.nombre_empaque_externo,p.cantidad_por_caja,p.observaciones,p.precio_compra,p.precio_almacen, " +
                            " p.precio_tienda,p.precio_iva,p.cod_estado_registro,er.nombre_estado_registro,u.cod_unidad_medida,u.nombre_unidad_medida,sg.cod_sub_grupo,sg.nombre_sub_grupo,uv.cod_unidad_medida cod_unidad_medida_compra,uv.nombre_unidad_medida nombre_unidad_medida_compra,p.cant_p_compra_venta,p.porc_desc_max,p.cod_barras_producto,p.imagen_producto " +
                            " FROM " +
                            " public.productos p " +
                            " inner join public.grupo_producto g on g.cod_grupo_producto = p.cod_grupo_producto  " +
                            " inner join public.estados_registro er on er.cod_estado_registro = p.cod_estado_registro " +
                            " inner join public.unidades_medida u on u.cod_unidad_medida = p.cod_unidad_medida " +
                            " left outer join public.proveedores pr1 on pr1.cod_proveedor = p.cod_proveedor1  " +
                            " left outer join public.proveedores pr2 on pr2.cod_proveedor = p.cod_proveedor2 " +
                            " left outer join public.empaque_externo e on e.cod_empaque_externo = p.cod_empaque_externo" +
                            " left outer join public.sub_grupos_producto sg on sg.cod_sub_grupo = p.cod_sub_grupo " +
                            " left outer join public.unidades_medida uv on uv.cod_unidad_medida = p.cod_unidad_medida_compra" +
                            " where p.cod_producto = '"+codProducto+"';  ";
                     
                     System.out.println("consulta " + consulta);
                     Statement st1 = utiles.getCon().createStatement();
                     ResultSet rs1 = st1.executeQuery(consulta);
                     out.print("<div align=center>"+
                               "<table class='tablaReportes' width='40%'>");
                     out.print("<tr>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo' width='50%'>NOMBRE</th>"
                                 +"<th class='bordeArriba bordeIzquierdo bordeAbajo bordeDerecho' width='50%'>DESCRIPCIÓN</th>"                                 
                                 + "</tr>");
                     
                     
                         if(rs1.next()){
                             
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Imagen:</td><td class='bordeAbajo bordeDerecho'><img src='"+rs1.getString("imagen_producto")+"' width='200' /></td></tr>");//data:image/jpg;base64,
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho bordeDerecho'>Nombre:</td><td class='bordeAbajo bordeDerecho'>"+(rs1.getString("nombre_producto")!=null?rs1.getString("nombre_producto"):"")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Descripcion:</td><td class='bordeAbajo bordeDerecho'>"+(rs1.getString("descripcion_producto")!=null?rs1.getString("descripcion_producto"):"")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Grupo:</td><td class='bordeAbajo bordeDerecho'>"+(rs1.getString("nombre_grupo_producto")!=null?rs1.getString("nombre_grupo_producto"):"")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Sub Grupo:</td><td class='bordeAbajo bordeDerecho'>"+(rs1.getString("nombre_sub_grupo")!=null?rs1.getString("nombre_sub_grupo"):"")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Proveedor 1:</td><td class='bordeAbajo bordeDerecho'>"+(rs1.getString("nombre_proveedor1")!=null?rs1.getString("nombre_proveedor1"):"")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Proveedor 2:</td><td class='bordeAbajo bordeDerecho'>"+(rs1.getString("nombre_proveedor2")!=null?rs1.getString("nombre_proveedor2"):"")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Descripcion Corta:</td><td class='bordeAbajo bordeDerecho'>"+(rs1.getString("descripcion_corta_producto")!=null?rs1.getString("descripcion_corta_producto"):"")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Stock Minimo:</td><td class='bordeAbajo bordeDerecho'>"+rs1.getDouble("stock_minimo")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Stock Maximo:</td><td class='bordeAbajo bordeDerecho'>"+rs1.getDouble("stock_maximo")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Observaciones:</td><td class='bordeAbajo bordeDerecho'>"+rs1.getString("observaciones")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Precio Compra:</td><td class='bordeAbajo bordeDerecho'>"+rs1.getDouble("precio_compra")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Precio Venta:</td><td class='bordeAbajo bordeDerecho'>"+rs1.getDouble("precio_tienda")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Estado:</td><td class='bordeAbajo bordeDerecho'>"+(rs1.getString("nombre_estado_registro")!=null?rs1.getString("nombre_estado_registro"):"")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Unidad:</td><td class='bordeAbajo bordeDerecho'>"+(rs1.getString("nombre_unidad_medida")!=null?rs1.getString("nombre_unidad_medida"):"")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>% Descuento Maximo:</td><td class='bordeAbajo bordeDerecho'>"+rs1.getDouble("porc_desc_max")+"</td></tr>");
                             out.print("<tr ><td class='bordeIzquierdo bordeAbajo bordeDerecho'>Codigo de Barras:</td><td class='bordeAbajo bordeDerecho'>"+(rs1.getString("cod_barras_producto")!=null?rs1.getString("cod_barras_producto"):"")+"</td></tr>");
                         }
                         out.print("<tr>"
                                     + "<td class='bordeAbajo bordeIzquierdo'>&nbsp;</td>"                                     
                                     + "<td class='bordeAbajo bordeDerecho'>&nbsp;</td>"                                     
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