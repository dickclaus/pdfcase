package org.asusual.pdfcase {

	/**
	 * PDFcase is the library to generate PDF files on client side with the Adobe Flash Player 10.
	 * Code is base on the Java PDFjet http://pdfjet.com 
	 * 
	 * @author Dmitry Bezverkhiy
	 * @version 0.1
	 * 
	 */
	public class CoreFont extends Object implements ICoreFont {		
		public static const COURIER : String = "Courier";
		public static const COURIER_BOLD : String = "Courier-Bold";
		public static const COURIER_OBLIQUE : String = "Courier-Oblique";
		public static const COURIER_BOLD_OBLIQUE : String = "Courier-BoldOblique";
		public static const HELVETICA : String = "Helvetica";
		public static const HELVETICA_BOLD : String = "Helvetica-Bold";
		public static const HELVETICA_OBLIQUE : String = "Helvetica-Oblique";
		public static const HELVETICA_BOLD_OBLIQUE : String = "Helvetica-BoldOblique";
		public static const TIMES_ROMAN : String = "Times-Roman";
		public static const TIMES_BOLD : String = "Times-Bold";
		public static const TIMES_ITALIC : String = "Times-Italic";
		public static const TIMES_BOLD_ITALIC : String = "Times-BoldItalic";
		public static const SYMBOL : String = "Symbol";
		public static const ZAPF_DINGBATS : String = "ZapfDingbats";
		
		public function getBBoxLLx() : int {
			// Implement me!!!
			
			return 0;
		}
		
		public function getBBoxLLy() : int {
			//Implement me!!!
			
			return 0;
		}
		
		public function getBBoxURx() : int {
			//Implement me!!!
			
			return 0;
		}
		
		public function getBBoxURy() : int {
			//Implement me!!!
			
			return 0;
		}
		
		public function getMetrics() : Array {
			//Implement me!!!
			
			return null;
		}    
	}
}
