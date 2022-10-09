/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package reporte.servlet;

import java.io.OutputStream;
import java.util.Map;

import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRParameter;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.query.JRXPathQueryExecuterFactory;
import net.sf.jasperreports.engine.util.JRLoader;



/**
 * Report Generator (JasperReports)
 * 
 * @author aperjor
 * 
 */
public class ReportGenerator {

    
    public static final String SUBREPORT_DIR_PARAM = "SUBREPORT_DIR";
    public static final String SUBREPORT_DIR = "jasper/";
    public static final String DATA_SOURCE_PARAM_XML = JRXPathQueryExecuterFactory.PARAMETER_XML_DATA_DOCUMENT;
    public static final String DATA_SOURCE_PARAM_COLLECTION = JRParameter.REPORT_DATA_SOURCE;

    /**
     * Create a pdf report with an xml data source
     * 
     * @param params
     *            the parameters (containing the data source for example)
     * @param jasperReport
     *            the JasperReport layout
     * @param outputStream
     *            the outputstream to write the pdf report
     * @throws JRException
     *             in case the report creation fails
     */
    public void exportReport(final Map<String, Object> params, final JasperReport jasperReport, final OutputStream outputStream)
            throws JRException {
        long start = System.currentTimeMillis();
        JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, params);
        JasperExportManager.exportReportToPdfStream(jasperPrint, outputStream);
        System.out.println("PDF creation time : {} ms");
    }

    /**
     * Retrieve a compiled {@link JasperReport} from the classpath
     * 
     * @param location
     *            the location on the classpath
     * @return the compiled report
     * @throws JRException
     *             in case of failure
     */
    public static JasperReport getCompiledReport(final String location) throws JRException {
        return (JasperReport) JRLoader.loadObject(JRLoader.getLocationInputStream(location));
    }

}