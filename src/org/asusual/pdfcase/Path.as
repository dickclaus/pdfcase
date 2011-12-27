package org.asusual.pdfcase {

	/**
	 * PDFcase is the library to generate PDF files on client side with the Adobe Flash Player 10.
	 * Code is base on the Java PDFjet http://pdfjet.com 
	 * 
	 * @author Dmitry Bezverkhiy
	 * @version 0.1
	 * 
	 */
	public class Path extends Object {
		private var color : Array = [0.0, 0.0, 0.0];
		private var width : Number = 0.3;
		private var pattern : String = "[] 0";
		private var fillShape : Boolean = false;
		private var closePath : Boolean = false;
		private var points : Array;
		private var boxX : Number = 0.0;
		private var boxY : Number = 0.0;

		public function Path() {
			points = [];        	
		}

		
		public function add(point : Point) : void {
			points.push(point);
		}

		
		public function setPattern(pattern : String) : void {
			this.pattern = pattern;
		}

		
		public function setWidth(width : Number) : void {
			this.width = width;
		}

		
		public function setColor(color : Array) : void {
			this.color = color;
		}

		
		public function setClosePath(closePath : Boolean) : void {
			this.closePath = closePath;
		}

		
		public function setFillShape(fillShape : Boolean) : void {
			this.fillShape = fillShape;
		}

		
		public function placeIn(box : Box, xOffset : Number, yOffset : Number) : void {
			boxX = box.x + xOffset;
			boxY = box.y + yOffset;
		}

		
		public function scaleBy(factor : Number) : void {
			for (var i : Number = 0;i < points.length; i++) {
				var point : Point = points[i];
				point.x *= factor;
				point.y *= factor;	
			}        
		}

		
		public function drawOn(page : Page) : void {
			if (fillShape) {
				page.setBrushColor(color[0], color[1], color[2]);
			} else {
				page.setPenColor(color[0], color[1], color[2]);
			}
			page.setPenWidth(width);
			page.setLinePattern(pattern);
			for (var i : Number = 0;i < points.length; i++) {
				var point : Point = points[i];
				point.x += boxX;
				point.y += boxY;
			}        

			if (fillShape) {
				page.drawPath(points, 'f');
			} else {
            	if (closePath) {
                	page.drawPath(points, 's');
            	} else {
                	page.drawPath(points, 'S');
            	}
        	}

	        for (var j : int = 0; j < points.length; j++) {
	            point = points[j];
	            point.x -= boxX;
	            point.y -= boxY;
	        }
		}
	}
}
