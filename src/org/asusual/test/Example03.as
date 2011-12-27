package org.asusual.test {
	import org.asusual.pdfcase.A4;
	import org.asusual.pdfcase.Font;
	import org.asusual.pdfcase.Image;
	import org.asusual.pdfcase.PDF;
	import org.asusual.pdfcase.Page;
	import org.asusual.pdfcase.TextLine;

	import flash.display.Bitmap;
	import flash.display.Sprite;

	/**
	 * @author dick
	 */
	public class Example03 extends Sprite {

		[Embed (source="/../assets/pdfcase/mt-map.gif")]
		private var Map : Class;
		
		[Embed (source="/../assets/pdfcase/papua.png")]
		private var Papua : Class;		
		
		[Embed (source="/../assets/pdfcase/cherry.jpg")]
		private var Cherry : Class;
		
		public function Example03() {			
			
			var map : Bitmap = new Map(); 
			var papua : Bitmap = new Papua();
			var cherry : Bitmap = new Cherry();			
			
			var pdf : PDF = new PDF();
			var page : Page = new Page(pdf, A4.PORTRAIT);

			var f1 : Font = new Font(pdf, "Helvetica");			
			var image1 : Image = new Image(pdf, papua.bitmapData,"papua.png");
			var image2 : Image = new Image(pdf, cherry.bitmapData, "cherry.jpg");
			var image3 : Image = new Image(pdf, map.bitmapData, "mt-map.gif");
			
			// Please note:
			// All font and image objects must be created
			// before the first page object.

			var text : TextLine  = new TextLine(f1,"The map below is an embedded PNG image");
        	text.setPosition(90.0, 30.0);
        	text.drawOn(page);

        	image1.setPosition(90, 40);
        	image1.drawOn(page);

        	text.setText("JPG image file embedded once and drawn 3 times");
        	text.setPosition(90.0, 550);
        	text.drawOn(page);

        	image2.setPosition(90, 560);
        	image2.scaleBy(0.5);
        	image2.drawOn(page);

        	image2.setPosition(260, 560);
        	image2.scaleBy(0.5);
        	image2.drawOn(page);

        	image2.setPosition(350, 560);
        	image2.scaleBy(0.5);
        	image2.drawOn(page);

        	text.setText("The map on the right is an embedded GIF image");
        	text.setPosition(90.0, 800);
        	text.drawOn(page);

	        image3.setPosition(390, 630);
	        image3.scaleBy(0.5);
	        image3.drawOn(page);
						
			pdf.wrap();
			pdf.save('example03.pdf');			
		}
	}
}
