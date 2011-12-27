package org.asusual.pdfcase {

	/**
	 * PDFcase is the library to generate PDF files on client side with the Adobe Flash Player 10.
	 * Code is base on the Java PDFjet http://pdfjet.com 
	 * 
	 * @author Dmitry Bezverkhiy
	 * @version 0.1
	 * 
	 */
	public class TextLine extends Object {
		protected var x : Number = 0.0;
		protected var y : Number = 0.0;
		protected var font : Font;
		protected var str : String = "";
		protected var uri : String = '';
		protected var underline : Boolean = false;
		protected var strike : Boolean = false;
		protected var degrees : int = 0;
		protected var color : Array = [0,0,0];
		private var boxX : Number = 0.0;
		private var boxY : Number = 0.0;

		public function TextLine(font : Font, str : String) {
			this.font = font;
			this.str = str;
		}

		public function setPosition(x : Number, y : Number) : void {
			this.x = x;
			this.y = y;
		}

		public function setText(str : String) : void {
			this.str = str;
		}

		public function setFont(font : Font) : void {
			this.font = font;
		}

		public function setColor(color : Array) : void {
			this.color = color;
		}

		public function getText() : String {
			return str;
		}

		public function getColor() : Array {
			return color;
		}

		public function setURIAction(uri : String) : void {
			this.uri = uri;
		}

		public function setUnderline(underline : Boolean) : void {
			this.underline = underline;
		}

		public function setStrikeLine(strike : Boolean) : void {
			this.strike = strike;
		}

		public function setTextDirection(degrees : int) : void {
			this.degrees = degrees;
		}

		public function placeIn(box : Box) : void {
			boxX = box.x;
			boxY = box.y;
		}

		public function drawOn(page : Page) : void {
			page.setTextDirection(degrees);
			x += boxX;
			y += boxY;
			if (uri != null) {
				page.annots.push(new Annotation(uri, x, page.height - (y - font.ascent), x + font.stringWidth(str), page.height - (y - font.descent)));
			}

			if (str != null) {
				page.setBrushColor(color[0], color[1], color[2]);
				page.drawString(font, str, x, y);
			}

			page.setPenWidth(0.25);
			if (underline) {
				page.moveTo(x, y + 0.75);
				page.lineTo(x + font.stringWidth(str), y + 0.75);
				page.strokePath();
			}

			if (strike) {
				page.moveTo(x, y - 3.5);
				page.lineTo(x + font.stringWidth(str), y - 3.5);
				page.strokePath();
			}
			page.setTextDirection(0);
		}
	}
}
