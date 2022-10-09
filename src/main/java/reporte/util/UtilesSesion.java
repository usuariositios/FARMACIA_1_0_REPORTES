/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reporte.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 *
 * @author HENRY VALDIVIA
 * En esta clase se guardan los datos de sesion como la imagen de empresa
 */
public class UtilesSesion {
    public  String logotipoEmpresa = "";
    public String nombreEmpresa = "";
    public int codEmpresa = 0;
    
    public void getLogotipoEmpresa(int codEmpresa1) throws Exception{
        
        Utiles utiles = new Utiles();
        utiles.getConnection();
        try {
            if(codEmpresa1==codEmpresa && (logotipoEmpresa==null || (logotipoEmpresa!=null && !logotipoEmpresa.trim().equals("")))){
                return;
            }
            Statement statement = utiles.getCon().createStatement();
            String cons = " select * from public.empresa where cod_empresa = '"+codEmpresa1+"' ";
            System.out.println("cons " + cons);
            ResultSet rs = statement.executeQuery(cons);
            if(rs.next()){
                logotipoEmpresa = rs.getString("logotipo_empresa");
                nombreEmpresa = rs.getString("nombre_empresa");
                codEmpresa = codEmpresa1;
            }
            
            statement.close();
            //connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        utiles.closeConnection();
    }
    
}
