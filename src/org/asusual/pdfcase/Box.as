package org.asusual.pdfcase {

	/**
	 * PDFcase is the library to generate PDF files on client side with the Adobe Flash Player 10.
	 * Code is base on the Java PDFjet http://pdfjet.com 
	 * 
	 * @author Dmitry Bezverkhiy
	 * @version 0.1
	 * 
	 */
	public class Box {
		public var x : Number = 0.0;
		public var y : Number = 0.0;
		
		private var w : Number = 0.0;
		private var h : Number = 0.0;
		
		private var color : Array = [0.0,0.0,0.0];		
		private var width : Number = 0.3;
		private var pattern : String = "[] 0";
		private var fillShape : Boolean = false;

		public function Box(x : Number = 0, y : Number = 0, w : Number = 0, h : Number = 0) {
			this.x = x;
			this.y = y;
			this.w = w;
			this.h = h;
		}

		public function   setPosition(x : Number, y : Number) : void {
			this.x = x;
			this.y = y;
		}

		public function   setSize(w : Number, h : Number) : void {
			this.w = w;
			this.h = h;
		}

		public function   setColor(color : Array) : void {
			this.color = color;
		}

		public function   setLineWidth(width : Number) : void {
			this.width = width;
		}

		public function   setPattern(pattern : String) : void {
			this.pattern = pattern;
		}

		public function   setFillShape(fillShape : Boolean) : void {
			this.fillShape = fillShape;
		}

		public function  placeIn(box : Box, xOffset : Number, yOffset : Number) : void {
			this.x = box.x + xOffset;
			this.y = box.y + yOffset;
		}

		public function  scaleBy(factor : Number) : void {
			this.x *= factor;
			this.y *= factor;
		}

		public function drawOn(page : Page) : void {						
			page.setPenWidth(width);
			page.setLinePattern(pattern);
			page.moveTo(x, y);
			page.lineTo(x + w, y);
			page.lineTo(x + w, y + h);
			page.lineTo(x, y + h);
			page.closePath();
			if (fillShape) {
				page.setBrushColor(color[0], color[1], color[2]);
				page.fillPath();
			} else {
				page.setPenColor(color[0], color[1], color[2]);
				page.strokePath();
			}
		}	
	}
}
