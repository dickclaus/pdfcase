package org.asusual.pdfcase {

	/**
	 * PDFcase is the library to generate PDF files on client side with the Adobe Flash Player 10.
	 * Code is base on the Java PDFjet http://pdfjet.com 
	 * 
	 * @author Dmitry Bezverkhiy
	 * @version 0.1
	 * 
	 */
	public class Line extends Object {
		private var x1 : Number = 0.0;
		private var y1 : Number = 0.0;
		private var x2 : Number = 0.0;
		private var y2 : Number = 0.0;
		private var boxX : Number = 0.0;
		private var boxY : Number = 0.0;
		private var color : Array = [0,0,0];
		private var width : Number = 0.3;
		private var pattern : String = "[] 0";

		public function Line(x1 : Number, y1 : Number, x2 : Number, y2 : Number) {
			this.x1 = x1;
			this.y1 = y1;
			this.x2 = x2;
			this.y2 = y2;
		}

		public function setPattern(pattern : String) : void {
			this.pattern = pattern;
		}

		public function setStartPoint(x : Number, y : Number) : void {
			this.x1 = x;
			this.y1 = y;
		}

		public function setEndPoint(x : Number, y : Number) : void {
			this.x2 = x;
			this.y2 = y;
		}

		public function getStartPoint() : Point {
			return new Point(x1, y1);
		}

		public function getEndPoint() : Point {
			return new Point(x2, y2);
		}

		public function setWidth(width : Number) : void {
			this.width = width;
		}

		public function setColor(color : Array) : void {
			this.color = color;
		}

		public function placeIn(box : Box, xOffset : Number = 0, yOffset : Number = 0) : void {
			boxX = box.x + xOffset;
			boxY = box.y + yOffset;
		}

		public function scaleBy(factor : Number) : void {
			this.x1 *= factor;
			this.x2 *= factor;
			this.y1 *= factor;
			this.y2 *= factor;
		}

		public function drawOn(page : Page) : void {
			color.push(0.0);
			color.push(0.0);
			color.push(0.0);
			page.setPenColor(color[0], color[1], color[2]);
			page.setPenWidth(width);
			page.setLinePattern(pattern);
			page.drawLine(x1 + boxX, y1 + boxY, x2 + boxX, y2 + boxY);
		}
	}
}
