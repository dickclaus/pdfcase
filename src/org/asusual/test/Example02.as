package org.asusual.test {
	import org.asusual.pdfcase.Page;
	import org.asusual.pdfcase.PDF;
	import org.asusual.pdfcase.Letter;
	import org.asusual.pdfcase.Path;
	import org.asusual.pdfcase.Point;
	import org.asusual.pdfcase.Box;
	import org.asusual.pdfcase.RGB;
	import flash.display.Sprite;

	/**
	 * @author dick
	 */
	public class Example02 extends Sprite {

		
		public function Example02() {
								
			var pdf : PDF = new PDF();
			var page : Page = new Page(pdf, Letter.PORTRAIT);

			var flag : Box = new Box(85, 85, 64, 32);
			var path : Path = new Path();
			path.add(new Point(13.0, 0.0));
			path.add(new Point(15.5, 4.5));
			path.add(new Point(18.0, 3.5));

			path.add(new Point(15.5, 13.5, Point.IS_CURVE_POINT));
			path.add(new Point(15.5, 13.5, Point.IS_CURVE_POINT));
			path.add(new Point(20.5, 7.5, Point.IS_CURVE_POINT));

			path.add(new Point(21.0, 9.5));
			path.add(new Point(25.0, 9.0));
			path.add(new Point(24.0, 13.0));
			path.add(new Point(25.5, 14.0));
			path.add(new Point(19.0, 19.0));
			path.add(new Point(20.0, 21.5));
			path.add(new Point(13.5, 20.5));
			path.add(new Point(13.5, 27.0));
			path.add(new Point(12.5, 27.0));
			path.add(new Point(12.5, 20.5));
			path.add(new Point(6.0, 21.5));
			path.add(new Point(7.0, 19.0));
			path.add(new Point(0.5, 14.0));
			path.add(new Point(2.0, 13.0));
			path.add(new Point(1.0, 9.0));
			path.add(new Point(5.0, 9.5));
			path.add(new Point(5.5, 7.5));

			path.add(new Point(10.5, 13.5, Point.IS_CURVE_POINT));
			path.add(new Point(10.5, 13.5, Point.IS_CURVE_POINT));
			path.add(new Point(8.0, 3.5, Point.IS_CURVE_POINT));

			path.add(new Point(10.5, 4.5));
			path.setClosePath(true);
			path.setColor(RGB.RED);
			path.setFillShape(true);
			path.placeIn(flag, 19.0, 3.0);
			path.drawOn(page);

			var box : Box = new Box();
			box.setSize(16, 32);
			box.setColor(RGB.RED);
			box.setFillShape(true);
			box.placeIn(flag, 0.0, 0.0);
			box.drawOn(page);
			box.placeIn(flag, 48.0, 0.0);
			box.drawOn(page);
			
			
			pdf.wrap();
			pdf.save('example02.pdf');			
		}
	}
}
