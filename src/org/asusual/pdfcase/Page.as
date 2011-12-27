package org.asusual.pdfcase {
	import flash.utils.ByteArray;	

	/**
	 * PDFcase is the library to generate PDF files on client side with the Adobe Flash Player 10.
	 * Code is base on the Java PDFjet http://pdfjet.com 
	 * 
	 * @author Dmitry Bezverkhiy
	 * @version 0.1
	 * 
	 */
	public class Page extends Object {
		public var buffer : ByteArray;
		protected var writingMode : String = "1 0 0 1 ";
		protected var renderingMode : int = 0;
		public var width : Number = 0.0;
		public var height : Number = 0.0;
		public var annots : Array;
		public var pdf : PDF;
		
		private var penColor : Array = [0,0,0];
		private var brushColor : Array = [0,0,0];
		private var penWidth : Number = 0.0;
		private var linePattern : String = "[] 0";

		public function Page(targetPDF : PDF, pageSize : Array) {
			pdf = targetPDF;
			annots = [];
			width = pageSize[0];
			height = pageSize[1];
			buffer = new ByteArray();
			pdf.pages.push(this);			
		}

		public function drawLine(x1 : Number, y1 : Number,x2 : Number, y2 : Number) : void {
			moveTo(x1, y1);
			lineTo(x2, y2);
			strokePath();
		}
		
		public function drawString(font : Font, str : String, x : Number, y : Number) : void {
			pdf.append(buffer, "BT\n");
			pdf.append(buffer, "/F");
			pdf.append(buffer, font.objNumber);
			pdf.append(buffer, ' ');
			pdf.append(buffer, font.size);
			pdf.append(buffer, " Tf\n");
			if (renderingMode != 0) {
				pdf.append(buffer, renderingMode);
				pdf.append(buffer, " Tr\n");
			}
			pdf.append(buffer, writingMode);
			pdf.append(buffer, x);
			pdf.append(buffer, ' ');
			pdf.append(buffer, (height - y));
			pdf.append(buffer, " Tm\n");
			pdf.addText(buffer, str, font);
			pdf.append(buffer, "ET\n");
		}
		
		public function setPenColor(r : Number, g : Number, b : Number) : void {
			if (penColor[0] == r && penColor[1] == g && penColor[2] == b) {
				return;
			} else {
				penColor[0] = r;
				penColor[1] = g;
				penColor[2] = b;
			}
			pdf.append(buffer,r);
			pdf.append(buffer,' ');
			pdf.append(buffer,g);
			pdf.append(buffer,' ');
			pdf.append(buffer,b);
			pdf.append(buffer," RG\n");
		}
		public function setBrushColor(r : Number, g : Number, b : Number) : void {
			if (brushColor[0] == r && brushColor[1] == g && brushColor[2] == b) {
				return;
			} else {
				brushColor[0] = r;
				brushColor[1] = g;
				brushColor[2] = b;
			}
			pdf.append(buffer,r);
			pdf.append(buffer,' ');
			pdf.append(buffer,g);
			pdf.append(buffer,' ');
			pdf.append(buffer,b);
			pdf.append(buffer," rg\n");
		}
		protected function setDefaultLineWidth() : void {
			pdf.append(buffer,0.0);
			pdf.append(buffer," w\n");
		}
		public function setLinePattern(pattern : String) : void {
			if (pattern == linePattern) {
				return;
			} else {
				linePattern = pattern;
			}
			if (pattern.charAt(0) == "[") {
				pdf.append(buffer,pattern);
			} else {
				var dash : int = 0;
				var space : int = 0;
				for (var i : Number = 0;i < pattern.length; i++) {
					if (pattern.charAt(i) == '-') {
						dash++;
					} else {
						space++;
					}
				}            
				if (dash == 0 || space == 0) {
					pdf.append(buffer,"[] 0");
				} else {
					pdf.append(buffer,"[" + dash / 2 + " " + space / 2 + "] 0");
				}
			}
			pdf.append(buffer," d\n");
		}
		protected function setDefaultLinePattern() : void {
			pdf.append(buffer,"[] 0");
			pdf.append(buffer," d\n");
		}
		public function setPenWidth(width : Number) : void {
			if (penWidth == width) {
				return;
			} else {
				penWidth = width;
			}
			pdf.append(buffer,penWidth);
			pdf.append(buffer," w\n");
		}

		public function moveTo(x : Number, y : Number) : void {
			pdf.append(buffer,x);
			pdf.append(buffer,' ');
			pdf.append(buffer,(height - y));
			pdf.append(buffer," m\n");
		}

		public function lineTo(x : Number, y : Number) : void {
			pdf.append(buffer,x);
			pdf.append(buffer,' ');
			pdf.append(buffer,(height - y));
			pdf.append(buffer," l\n");
		}
		public function closePath() : void {
			pdf.append(buffer,"h\n");
		}

		public function strokePath() : void {
			pdf.append(buffer,"S\n");
		}

		public function fillPath() : void {
			pdf.append(buffer,"f\n");
		}

		public function drawPath (list : Array, operand : String) : void {
			if (list.length < 2) {
				throw new Error("The Path object must contain at least 2 points");
			}
			var point : Point = list[0];
			moveTo(point.getX(), point.getY());
			var numOfCurvePoints : int = 0;
			for (var i : Number = 1;i < list.length; i++) {
				point = list[i];
				if (point.isCurvePoint) {
					pdf.append(buffer,point.getX());
					pdf.append(buffer,' ');
					pdf.append(buffer,(height - point.getY()));
					if (numOfCurvePoints < 2) {
						pdf.append(buffer,' ');
						numOfCurvePoints++;
					} else {
						pdf.append(buffer," c\n");
						numOfCurvePoints = 0;
					}
				} else {
					lineTo(point.getX(), point.getY());
				}
			}
        
			if (numOfCurvePoints != 0) {
				throw new Error("Invalid number of curve points in the Path object");
			}
			pdf.append(buffer,operand);
			pdf.append(buffer,'\n');
		}

		protected function drawBezierCurve(list : Array, operand : String) : void {
			var point : Point = list[0];
			moveTo(point.getX(), point.getY());
			for (var i : Number = 1;i < list.length; i++) {
				point = list[i];
				pdf.append(buffer,point.getX());
				pdf.append(buffer,' ');
				pdf.append(buffer,(height - point.getY()));
				if (i % 3 == 0) {
					pdf.append(buffer," c\n");
				} else {
					pdf.append(buffer,' ');
				}
			}
			pdf.append(buffer,operand);
			pdf.append(buffer,'\n');
		}

		protected function drawCircle(x : Number, y : Number, r : Number, operand : String) : void {
			var list : Array = [];

			var point : Point = new Point(x,y);
			point.setY(y - r);
			// Starting point
			list.push(point);    
			
			point = new Point(x + 0.55 * r, y - r);
			list.push(point);
			point = new Point(x + r, y - 0.55 * r);
			list.push(point);
			point = new Point(x + r, y);
			list.push(point);
        
			point = new Point(x + r, y + 0.55 * r);
			list.push(point);
			point = new Point(x + 0.55 * r, y + r);
			list.push(point);
			point = new Point(x, y + r);
			list.push(point);
        
			point = new Point(x - 0.55 * r, y + r);
			list.push(point);
			point = new Point(x - r, y + 0.55 * r);
			list.push(point);
			point = new Point(x - r, y);
			list.push(point);
        
			point = new Point(x - r, y - 0.55 * r);
			list.push(point);
			point = new Point(x - 0.55 * r, y - r);
			list.push(point);
			point = new Point(x, y - r);
			list.push(point);        

			drawBezierCurve(list, operand);
		}

		public function drawPoint(p : Point) : void {
			if (p.shape == Point.INVISIBLE) return;

			var list : Array = [];
			var point : Point;

			if (p.shape == Point.CIRCLE) {
				if (p.fillShape) {
					drawCircle(p.getX(), p.getY(), p.getRadius(), 'f');
				} else {
					drawCircle(p.getX(), p.getY(), p.getRadius(), 'S');
				}
			} else if (p.shape == Point.DIAMOND) {
				list = [];
				point = new Point(p.getX(), p.getY() - p.getRadius());
				list.push(point);
				point = new Point(p.getX() + p.getRadius(), p.getY());
				list.push(point);
				point = new Point(p.getX() + p.getRadius(), p.getY());
				list.push(point);
				point = new Point(p.getX(), p.getY() + p.getRadius());
				list.push(point);
				point = new Point(p.getX() - p.getRadius(), p.getY());
				list.push(point);
				if (p.fillShape) {
					drawPath(list, 'f');
				} else {
					drawPath(list, 's');
				}
			} else if (p.shape == Point.BOX) {
				list = [];
				point = new Point(p.getX() - p.getRadius(), p.getY() - p.getRadius());
				list.push(point);
				point = new Point(p.getX() + p.getRadius(), p.getY() - p.getRadius());
				list.push(point);         
				point = new Point(p.getX() + p.getRadius(), p.getY() + p.getRadius());
				list.push(point);
				point = new Point(p.getX() - p.getRadius(), p.getY() + p.getRadius());
				list.push(point);
           		if (p.fillShape) {
					drawPath(list, 'f');
				} else {
					drawPath(list, 's');
				}
			} else if (p.shape == Point.PLUS) {
				drawLine(p.getX() - p.getRadius(), p.getY(), p.getX() + p.getRadius(), p.getY());
				drawLine(p.getX(), p.getY() - p.getRadius(), p.getX(), p.getY() + p.getRadius());
			} else if (p.shape == Point.UP_ARROW) {
				list = [];
				point = new Point(p.getX(), p.getY() - p.getRadius());
				list.push(point);
				point = new Point(p.getX() + p.getRadius(), p.getY() + p.getRadius());
				list.push(point);
				point = new Point(p.getX() - p.getRadius(), p.getY() + p.getRadius());
				list.push(point);
				if (p.fillShape) {
					drawPath(list, 'f');
				} else {
					drawPath(list, 's');
				}
			} else if (p.shape == Point.DOWN_ARROW) {
				list = [];
				point = new Point(p.getX() - p.getRadius(), p.getY() - p.getRadius());
				list.push(point);
				point = new Point(p.getX() + p.getRadius(), p.getY() - p.getRadius());
           		list.push(point);
				point = new Point(p.getX(), p.getY() + p.getRadius());
				list.push(point);
           		if (p.fillShape) {
					drawPath(list, 'f');
				} else {
					drawPath(list, 's');
				}
			} else if (p.shape == Point.LEFT_ARROW) {
				list = [];
				point = new Point(p.getX() + p.getRadius(), p.getY() + p.getRadius());
				list.push(point);
				point = new Point(p.getX() - p.getRadius(), p.getY());
				list.push(point);
				point = new Point(p.getX() + p.getRadius(), p.getY() - p.getRadius());
				list.push(point);
            
				if (p.fillShape) {
					drawPath(list, 'f');
				} else {
					drawPath(list, 's');
				}
			} else if (p.shape == Point.RIGHT_ARROW) {
				list = [];
				point = new Point(p.getX() - p.getRadius(), p.getY() - p.getRadius());
				list.push(point);
				point = new Point(p.getX() + p.getRadius(), p.getY());
				list.push(point);
				point = new Point(p.getX() - p.getRadius(), p.getY() + p.getRadius());
				list.push(point);            
				if (p.fillShape) {
					drawPath(list, 'f');
				} else {
					drawPath(list, 's');
				}
			} else if (p.shape == Point.H_DASH) {
				drawLine(p.getX() - p.getRadius(), p.getY(), p.getX() + p.getRadius(), p.getY());
			} else if (p.shape == Point.V_DASH) {
				drawLine(p.getX(), p.getY() - p.getRadius(), p.getX(), p.getY() + p.getRadius());
			} else if (p.shape == Point.X_MARK) {
				drawLine(p.getX() - p.getRadius(), p.getY() - p.getRadius(), p.getX() + p.getRadius(), p.getY() + p.getRadius());
				drawLine(p.getX() - p.getRadius(), p.getY() + p.getRadius(), p.getX() + p.getRadius(), p.getY() - p.getRadius());
			} else if (p.shape == Point.MULTIPLY) {
				drawLine(p.getX() - p.getRadius(), p.getY() - p.getRadius(), p.getX() + p.getRadius(), p.getY() + p.getRadius());
				drawLine(p.getX() - p.getRadius(), p.getY() + p.getRadius(), p.getX() + p.getRadius(), p.getY() - p.getRadius());
				drawLine(p.getX() - p.getRadius(), p.getY(), p.getX() + p.getRadius(), p.getY());
				drawLine(p.getX(), p.getY() - p.getRadius(), p.getX(), p.getY() + p.getRadius());
			} else if (p.shape == Point.STAR) {
				var angle : Number = Math.PI / 10;
				var sin18 : Number = Math.sin(angle);
				var cos18 : Number = Math.cos(angle);
				var a : Number = p.getRadius() * cos18;
				var b : Number = p.getRadius() * sin18;
				var c : Number = 2 * a * sin18;
				var d : Number = 2 * a * cos18 - p.getRadius();
				list = [];        
				point = new Point(p.getX(), p.getY() - p.getRadius());
				list.push(point);
				point = new Point(p.getX() + c, p.getY() + d);
				list.push(point);
				point = new Point(p.getX() - a, p.getY() - b);
				list.push(point);
				point = new Point(p.getX() + a, p.getY() - b);
				list.push(point);
				point = new Point(p.getX() - c, p.getY() + d);
				list.push(point);
				if (p.fillShape) {
					drawPath(list, 'f');
				} else {
					drawPath(list, 's');
				}
			}
		}

		protected function setTextRenderingMode(mode : int) : void {
			if (mode == 0 || mode == 1 || mode == 2 || mode == 3 || mode == 4 || mode == 5 || mode == 6 || mode == 7) {
				this.renderingMode = mode;
			} else {
				throw new Error("Invalid text rendering mode: " + mode);
			}
		}


		public function setTextDirection(degrees : int) : void {
			if (degrees > 360) degrees %= 360;
			if (degrees == 0) {
				writingMode = "1 0 0 1 ";
			} else if (degrees == 90) {
				writingMode = "0 1 -1 0 ";
			} else if (degrees == 180) {
				writingMode = "-1 0 0 -1 ";
			} else if (degrees == 270) {
				writingMode = "0 -1 1 0 ";
			} else if (degrees == 360) {
				writingMode = "1 0 0 1 ";
			} else {
				var sinOfAngle : Number = Math.sin(degrees * (Math.PI / 180));
				var cosOfAngle : Number = Math.cos(degrees * (Math.PI / 180));
				var sb : String = '';
				sb += cosOfAngle;
				sb += ' ';
				sb += sinOfAngle;
				sb += ' ';
				sb += -sinOfAngle;
				sb += ' ';
				sb += cosOfAngle;
				sb += ' ';
				writingMode = sb.toString();
			}
		}
	}
}
