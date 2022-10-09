/*
* JasperToExcel.java
 */
package reporte.servlet;

import java.io.*;
import java.util.HashMap;
import javax.servlet.*;
import javax.servlet.http.*;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.export.JExcelApiExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import reporte.util.Utiles;
import java.sql.*;
import java.util.Enumeration;
import java.util.Map;

/**
 *
 * @author amontejo
 * @version
 */
public class JasperToExcel extends HttpServlet {

    //public static final String REPORT_DIRECTORY = "/reports";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException,Exception {
        Utiles utiles = new Utiles();
        utiles.getConnection();
        try {
        ServletContext context = this.getServletConfig().getServletContext();
        
        HttpSession session = request.getSession();
        String nombreReporte = request.getParameter("nombreReporte");//parametros de ubicacion fija
        String nombreLogotipo = request.getParameter("nombreLogotipo");
        //String selectedyear = request.getParameter("SelectedYear");
        //InputStream reportStream = getServletConfig().getServletContext().getResourceAsStream("/" + REPORT_DIRECTORY + "/" + reportName + ".jasper");
        String reportFileName = context.getRealPath(nombreReporte); //"/reportes/reportePlanDeCuentas.jasper"
        
        
        
        JasperPrint jasperPrint = null;
        //HashMap parameterMap = new HashMap();

        //parameterMap.put("parayear", new String(selectedyear));
        
        
        Map parameters = new HashMap();
        //parameters.put("cod_comprobante",8);
        parameters.put("SUBREPORT_DIR",context.getRealPath(nombreReporte)); // "/reportes/reportePlanDeCuentas.jasper"  es que ahora el path sub report es $P{SUB_REPORT}+"nombre_reporte.jasper"
        parameters.put("logotipo",context.getRealPath(nombreLogotipo));//"/images/logotipo.jpg"
        
        //revision de los parametros del reporte
        Enumeration en = request.getParameterNames();
        while (en.hasMoreElements()) {
            
            String nomParametro = (String) en.nextElement();
            if(!nomParametro.equals("SUBREPORT_DIR") && !nomParametro.equals("logotipo"))
            {
                parameters.put(nomParametro,request.getParameter(nomParametro));
            }
            System.out.println(nomParametro + " - " +request.getParameter(nomParametro));
        }

        
            //ServletOutputStream servletOutputStream = response.getOutputStream();
            //JRDataSource dataSource = createReportDataSource(request, selectedyear, reportName);
            jasperPrint = JasperFillManager.fillReport(reportFileName, parameters, utiles.getCon());
            generateXLSOutput("reporte_excel", jasperPrint, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
        utiles.closeConnection();
    }

    private String tagreport(String string) {
        java.util.Calendar calendar = java.util.Calendar.getInstance();
        return string + calendar.get(calendar.MONTH) + calendar.get(calendar.DAY_OF_MONTH) + calendar.get(calendar.YEAR);
    }

    private void generateXLSOutput(String reportname,
            JasperPrint jasperPrint,
            HttpServletResponse resp)
            throws IOException, JRException {
        String reportfilename = tagreport(reportname) + ".xls";
        JExcelApiExporter exporterXLS = new JExcelApiExporter();

        exporterXLS.setParameter(JRXlsExporterParameter.JASPER_PRINT, jasperPrint);
        exporterXLS.setParameter(JRXlsExporterParameter.IS_DETECT_CELL_TYPE, Boolean.TRUE);
        exporterXLS.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
        exporterXLS.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
        exporterXLS.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, resp.getOutputStream());
        resp.setHeader("Content-Disposition", "inline;filename=" + reportfilename);
        resp.setContentType("application/vnd.ms-excel");

        exporterXLS.exportReport();
    }

// 
    /**
     * Handles the HTTP GET method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try{
        processRequest(request, response);
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    /**
     * Handles the HTTP POST method.
     *
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try{
        processRequest(request, response);
        }catch(Exception e){e.printStackTrace();}
    }

    /**
     * Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }
// 
}
