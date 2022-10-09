/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reporte.servlet;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletContext;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JRParameter;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
//import static sun.management.ConnectorAddressLink.export;
/**
 *
 * @author Computer
 */
public class ReporteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    

    @Override
    protected void doGet(final HttpServletRequest request, final HttpServletResponse response) throws ServletException, IOException {
        ServletContext context = request.getServletContext();
        System.out.println("generate the report" + context.getRealPath("/comprobante/reporteComprobante.jasper"));
        
        ReportGenerator reportGenerator = new ReportGenerator();
        Map<String, Object> params;
        params = new HashMap<String, Object>();
        params.put("SUBREPORT_DIR", context.getRealPath("/comprobante/reporteComprobante.jasper"));
        params.put("cod_comprobante",10);
        params.put("logotipo",context.getRealPath("/images/logotipo.jpg"));
        params.put(JRParameter.REPORT_LOCALE, request.getLocale());
        try {
            //InputStream xmlData = getClass().getResourceAsStream("/data/northwind.xml");
            //Document document = JRXmlUtils.parse(xmlData);
            //params.put(JRXPathQueryExecuterFactory.PARAMETER_XML_DATA_DOCUMENT, document);
            JasperReport jasperReport = ReportGenerator.getCompiledReport(context.getRealPath("/comprobante/reporteComprobante.jasper"));
            prepareDownloadXLS(response, "report.xls");
            reportGenerator.exportReport(params, jasperReport, response.getOutputStream());
            response.getOutputStream().close();
        } catch (JRException e) {
            System.out.println("error while generating the report");
            response.sendError(500, "unable to generate report");
        }
    }

    private void prepareDownload(final HttpServletResponse response, final String filename) {
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment;filename=" + filename);
        response.setHeader("Expires", "0");
        response.setHeader("Pragma", "cache");
        response.setHeader("Cache-Control", "private");
    }
    private void prepareDownloadXLS(final HttpServletResponse response, final String filename) {
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment;filename=" + filename);
        response.setHeader("Expires", "0");
        response.setHeader("Pragma", "cache");
        response.setHeader("Cache-Control", "private");
    }
    /*public void generateReport(JasperPrint report, boolean isExcel, String saveTo) {
        JRExporter exporter = null;
        if (isExcel) {
            exporter = new JRXlsExporter();
            exporter.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
            exporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, Boolean.FALSE);
            exporter.setParameter(JRXlsExporterParameter.IS_DETECT_CELL_TYPE, Boolean.TRUE);
            //we set the one page per sheet parameter here
            exporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, Boolean.TRUE);
        } else {
            exporter = new JRPdfExporter();
        }
        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, saveTo);
        export.exportReport();
    }*/

}