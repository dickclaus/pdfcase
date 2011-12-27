package org.asusual.pdfcase {

	/**
	 * PDFcase is the library to generate PDF files on client side with the Adobe Flash Player 10.
	 * Code is base on the Java PDFjet http://pdfjet.com 
	 * 
	 * @author Dmitry Bezverkhiy
	 * @version 0.1
	 * 
	 */
	public interface ICoreFont {
		
		function getBBoxLLx() : int;
    	function getBBoxLLy() : int;
    	function getBBoxURx() : int;
    	function getBBoxURy() : int;
    	function getMetrics() : Array;
	}
}
