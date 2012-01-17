package org.asusual.pdfcase.test {
	import org.asusual.pdfcase.Page;
	import org.asusual.pdfcase.PDF;
	import org.asusual.pdfcase.TextLine;	
	import org.asusual.pdfcase.Letter;
	import org.asusual.pdfcase.Font;
	import org.asusual.pdfcase.Point;
	import org.asusual.pdfcase.RGB;
	import flash.display.Sprite;

	/**
	 * @author dick
	 */
	public class Example05 extends Sprite {

		public function Example05() {
			var pdf : PDF = new PDF();
			var f1 : Font = new Font(pdf, "Helvetica");
			
        	var page : Page = new Page(pdf, Letter.PORTRAIT);

        	var text : TextLine = new TextLine(f1, "             Hello, World.");
        	text.setPosition(300.0, 300.0);
        	for (var i : int = 0; i < 360; i += 15) {
            	text.setTextDirection(i);
            	text.drawOn(page);
        	}

	        text = new TextLine(f1, "WAVE AWAY");
	        text.setPosition(70.0, 50.0);
	        text.drawOn(page);
	
	        f1.setKernPairs(true);
	        text.setPosition(70.0, 70.0);
	        text.drawOn(page);
	
	        f1.setKernPairs(false);
	        text.setPosition(70.0, 90.0);
	        text.drawOn(page);
	
	        f1.setSize(8);
	        text = new TextLine(f1, "-- font.setKernPairs(false);");
	        text.setPosition(150.0, 50.0);
	        text.drawOn(page);
	        text.setPosition(150.0, 90.0);
	        text.drawOn(page);
	        text = new TextLine(f1, "-- font.setKernPairs(true);");
	        text.setPosition(150.0, 70.0);
	        text.drawOn(page);

        	var point : Point = new Point(300.0, 300.0);
        	point.setShape(Point.CIRCLE);
        	point.setFillShape(true);
        	point.setColor(RGB.BLUE);
        	point.setRadius(37.0);
        	point.drawOn(page);
        	point.setRadius(25.0);
        	point.setColor(RGB.WHITE);
        	point.drawOn(page);
        	
			pdf.wrap();
			pdf.save("example05.pdf");
		
		}
	}
}
