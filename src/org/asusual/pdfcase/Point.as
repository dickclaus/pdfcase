package org.asusual.pdfcase {

	/**
	 * PDFcase is the library to generate PDF files on client side with the Adobe Flash Player 10.
	 * Code is base on the Java PDFjet http://pdfjet.com 
	 * 
	 * @author Dmitry Bezverkhiy
	 * @version 0.1
	 * 
	 */
	public class Point extends Object {
		public static const INVISIBLE : int = -1;
		public static const CIRCLE : int = 0;
		public static const DIAMOND : int = 1;
		public static const BOX : int = 2;
		public static const PLUS : int = 3;
		public static const H_DASH : int = 4;
		public static const V_DASH : int = 5;
		public static const MULTIPLY : int = 6;
		public static const STAR : int = 7;
		public static const X_MARK : int = 8;
		public static const UP_ARROW : int = 9;
		public static const DOWN_ARROW : int = 10;
		public static const LEFT_ARROW : int = 11;
		public static const RIGHT_ARROW : int = 12;
		public static const IS_CURVE_POINT : Boolean = true;
		public var x : Number = 0.0;
		public var y : Number = 0.0;
		protected var r : Number = 2.0;
		public var shape : int = 0;
		public var color : Array = [0,0,0];		
		public var lineWidth : Number = 0.3;
		public var linePattern : String = "[] 0";
		public var fillShape : Boolean = false;
		public var isCurvePoint : Boolean = false;
		protected var text : String = '';
		public var uri : String = '';
		protected var info : Array = [];
		// drawLineTo == false means:
		//      Don't draw a line to this point from the previous
		protected var drawLineTo : Boolean = false;
		private var boxX : Number = 0.0;
		private var boxY : Number = 0.0;

		public function Point(x : Number, y : Number, isCurvePoint : Boolean = false) {
			this.x = x;
			this.y = y;
			this.isCurvePoint = isCurvePoint;
		}    

		public function setPosition(x : Number, y : Number) : void {
			this.x = x;
			this.y = y;
		}

		public function setX(x : Number) : void {
			this.x = x;
		}

		public function getX() : Number {
			return x;
		}

		public function setY(y : Number) : void {
			this.y = y;
		}

		public function getY() : Number {
			return y;
		}

		public function setRadius(r : Number) : void {
			this.r = r;
		}

		public function getRadius() : Number {
			return r;
		}

		public function setShape(shape : int) : void {
			this.shape = shape;
		}

		public function getShape() : Number {
			return shape;
		}

		public function setFillShape(fill : Boolean) : void {
			this.fillShape = fill;
		}

		public function getFillShape() : Boolean {
			return fillShape;
		}

		public function setColor(color : Array) : void {
			this.color = color;
		}

		public function getColor() : Array {
			return color;
		}

		public function setLineWidth(lineWidth : Number) : void {
			this.lineWidth = lineWidth;
		}

		public function getLineWidth() : Number {
			return lineWidth;
		}

		public function setLinePattern(linePattern : String) : void {
			this.linePattern = linePattern;
		}

		public function getLinePattern() : String {
			return linePattern;
		}

		public function setDrawLineTo(drawLineTo : Boolean) : void {
			this.drawLineTo = drawLineTo;
		}

		public function getDrawLineTo() : Boolean {
			return drawLineTo;
		}

		public function setURIAction(uri : String) : void {
			this.uri = uri;
		}

		public function getURIAction() : String {
			return uri;
		}

		public function setText(text : String) : void {
			this.text = text;
		}

		public function getText() : String {
			return text;
		}

		public function setInfo(info : Array) : void {
			this.info = info;
		}

		public function getInfo() : Array {
			return info;
		}

		public function placeIn(box : Box, xOffset : Number, yOffset : Number) : void {
			boxX = box.x + xOffset;
			boxY = box.y + yOffset;
		}

		public function drawOn(page : Page) : void {			
			page.setPenWidth(lineWidth);
			page.setLinePattern(linePattern);

			if (fillShape) {
				page.setBrushColor(color[0], color[1], color[2]);
			} else {
				page.setPenColor(color[0], color[1], color[2]);
			}

			x += boxX;
			y += boxY;
			page.drawPoint(this);
			x -= boxX;
			y -= boxY;
		}
	}
}
