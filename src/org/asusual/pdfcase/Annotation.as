package org.asusual.pdfcase {

	/**
	 * PDFcase is the library to generate PDF files on client side with the Adobe Flash Player 10.
	 * Code is base on the Java PDFjet http://pdfjet.com 
	 * 
	 * @author Dmitry Bezverkhiy
	 * @version 0.1
	 * 
	 */
	public class Annotation { 	
		public var uri : String = null;    
		public var x1 : Number = 0.0;
		public var y1 : Number = 0.0;
		public var x2 : Number = 0.0;
		public var y2 : Number = 0.0;

		public function Annotation(uri : String, x1 : Number, y1 : Number, x2 : Number, y2 : Number) {
			this.uri = uri;
			this.x1 = x1;
			this.y1 = y1;
			this.x2 = x2;
			this.y2 = y2;
		}
	} 
}
