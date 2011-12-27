package org.asusual.test {
	import org.asusual.pdfcase.Point;
	import org.asusual.pdfcase.Page;
	import org.asusual.pdfcase.PDF;
	import org.asusual.pdfcase.Letter;
	import org.asusual.pdfcase.Box;
	import org.asusual.pdfcase.Line;
	import org.asusual.pdfcase.RGB;
	import flash.display.Sprite;

	/**
	 * @author dick
	 */
	public class Example01 extends Sprite {		
				
		public function Example01() {			
						
			var pdf : PDF = new PDF();
			var page : Page = new Page(pdf, Letter.PORTRAIT);

			var flag : Box = new Box();
			flag.setPosition(100.0, 100.0);
			flag.setSize(190.0, 100.0);
			flag.setColor(RGB.WHITE);
			flag.setFillShape(true);
			flag.setLineWidth(0.0);						
			flag.drawOn(page);

			var sw : Number = 7.69;   // stripe width
			var stripe : Line = new Line(0.0, sw / 2, 190.0, sw / 2);
			stripe.setWidth(sw);
			stripe.setColor(RGB.OLD_GLORY_RED);
			for (var row : int = 0;row < 7; row++) {
				stripe.placeIn(flag, 0.0, row * 2 * sw);
				stripe.drawOn(page);
			}

			var union : Box = new Box();
			union.setSize(76.0, 53.85);
			union.setColor(RGB.OLD_GLORY_BLUE);
			union.setFillShape(true);
			union.placeIn(flag, 0.0, 0.0);
			union.drawOn(page);

			var hSi : Number = 12.6; // horizontal star interval
						
			var vSi : Number = 10.8; // vertical star interval
						
			var star : Point = new Point(hSi / 2, vSi / 2);
			star.setShape(Point.STAR);
			star.setRadius(3.0);
			star.setColor(RGB.WHITE);
			star.setFillShape(true);

			for (var row1 : int = 0;row1 < 6; row1++) {
				for (var col : int = 0;col < 5; col++) {
					star.placeIn(union, row1 * hSi, col * vSi);
					star.drawOn(page);
				}
			}
			star.setPosition(hSi, vSi);
			for (var row2 : int = 0;row2 < 5; row2++) {
				for (var col1 : int = 0;col1 < 4; col1++) {
					star.placeIn(union, row2 * hSi, col1 * vSi);
					star.drawOn(page);
				}
			}

			pdf.wrap();
			pdf.save('example01.pdf');			
		}
	}
}
