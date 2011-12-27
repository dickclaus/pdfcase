package org.asusual.pdfcase {
	import flash.utils.getDefinitionByName;

	/**
	 * PDFcase is the library to generate PDF files on client side with the Adobe Flash Player 10.
	 * Code is base on the Java PDFjet http://pdfjet.com 
	 * 
	 * @author Dmitry Bezverkhiy
	 * @version 0.1
	 * 
	 */
	public class Font extends Object {

		public var name : String = null;		
		public var objNumber : int = 0;
		// The object number of the embedded font file
		protected var fileObjNumber : int = -1;
		// Font attributes
		public var size : Number = 12.0;
		protected var unitsPerEm : int = 1000;
		public var ascent : Number = 0.0;
		public var descent : Number = 0.0;
		protected var bodyHeight : Number = 0.0;
		// Font metrics
		public var metrics : Array = [];
		// Don't change the following default values!
		public var isStandard : Boolean = true;
		public var kernPairs : Boolean = false;
		public var isComposite : Boolean = false;
		public var firstChar : int = 32;
		public var lastChar : int = 255;

		private var pdf : PDF;

		private var isCJK : Boolean = false;
		private var codePage : int = CodePage.CP1251;
		// Font bounding box
		private var  bBoxLLx : Number = 0.0;
		private var  bBoxLLy : Number = 0.0;
		private var  bBoxURx : Number = 0.0;
		private var  bBoxURy : Number = 0.0;

		private var advanceWidths : Array = [];
		private var glyphWidth : Array = [];

		public function Font(pdf : PDF, fontName : String, codePage : int = int.MIN_VALUE) {
			//for Compiler;
			Courier;
			CourierBold;
			CourierBoldOblique;
			CourierOblique;
			
			Helvetica;
			HelveticaBold;			
			HelveticaBoldOblique;
			HelveticaOblique;
			
			TimesRoman;
			TimesBold;
			TimesBoldItalic;
			TimesItalic;
			
			Symbol;
			ZapfDingbats;
			
			this.pdf = pdf;
			this.name = fontName;
			if (codePage == int.MIN_VALUE) {
				pdf.newobj();
				pdf.append(pdf.buffer, "<<\n");
				pdf.append(pdf.buffer, "/Type /Font\n");
				pdf.append(pdf.buffer, "/Subtype /Type1\n");
				pdf.append(pdf.buffer, "/BaseFont /");
				pdf.append(pdf.buffer, name);
				pdf.append(pdf.buffer, '\n');
				if (fontName == "Symbol" || fontName == "ZapfDingbats" ) {
            		// Use the built-in encoding
        		} else {
					pdf.append(pdf.buffer, "/Encoding /WinAnsiEncoding\n");
				}
				pdf.append(pdf.buffer, ">>\n");
				pdf.endobj();
				objNumber = pdf.objNumber;
			
				var fontClass : Class = getDefinitionByName('org.asusual.pdfcase.' + name) as Class;
				var font : CoreFont = new fontClass();		
				bBoxLLx = font.getBBoxLLx();
				bBoxLLy = font.getBBoxLLy();
				bBoxURx = font.getBBoxURx();
				bBoxURy = font.getBBoxURy();
				metrics = font.getMetrics();
				ascent = bBoxURy * size / unitsPerEm;
				descent = bBoxLLy * size / unitsPerEm;
				bodyHeight = ascent - descent;
			} else {
				this.codePage = codePage;
				isCJK = true;
				isStandard = false;
				isComposite = true;

				firstChar = 0x0020;
				lastChar = 0xFFEE;

				// Font Descriptor
				pdf.newobj();
				pdf.append(pdf.buffer, "<<\n");
				pdf.append(pdf.buffer, "/Type /FontDescriptor\n");
				pdf.append(pdf.buffer, "/FontName /");
				pdf.append(pdf.buffer, name);
				pdf.append(pdf.buffer, '\n');
				pdf.append(pdf.buffer, "/Flags 4\n");
				pdf.append(pdf.buffer, "/FontBBox [0 0 0 0]\n");
				pdf.append(pdf.buffer, ">>\n");
				pdf.endobj();

				// CIDFont Dictionary
				pdf.newobj();
				pdf.append(pdf.buffer, "<<\n");
				pdf.append(pdf.buffer, "/Type /Font\n");
				pdf.append(pdf.buffer, "/Subtype /CIDFontType0\n");
				pdf.append(pdf.buffer, "/BaseFont /");
				pdf.append(pdf.buffer, name);
				pdf.append(pdf.buffer, '\n');
				pdf.append(pdf.buffer, "/FontDescriptor ");
				pdf.append(pdf.buffer, pdf.objNumber - 1);
				pdf.append(pdf.buffer, " 0 R\n");
				pdf.append(pdf.buffer, "/CIDSystemInfo <<\n");
				pdf.append(pdf.buffer, "/Registry (Adobe)\n");
				if (name.indexOf("AdobeMingStd") == 0) {
					pdf.append(pdf.buffer, "/Ordering (CNS1)\n");
					pdf.append(pdf.buffer, "/Supplement 4\n");
				} else if (name.indexOf("AdobeSongStd") == 0) {
					pdf.append(pdf.buffer, "/Ordering (GB1)\n");
					pdf.append(pdf.buffer, "/Supplement 4\n");
				} else if (name.indexOf("KozMinPro") == 0) {
					pdf.append(pdf.buffer, "/Ordering (Japan1)\n");
					pdf.append(pdf.buffer, "/Supplement 4\n");
				} else if (name.indexOf("AdobeMyungjoStd") == 0) {
					pdf.append(pdf.buffer, "/Ordering (Korea1)\n");
					pdf.append(pdf.buffer, "/Supplement 1\n");
				} else {
					throw new Error("Unsupported font: " + name);
				}
				pdf.append(pdf.buffer, ">>\n");
				pdf.append(pdf.buffer, ">>\n");
				pdf.endobj();

				// Type0 Font Dictionary
				pdf.newobj();
				pdf.append(pdf.buffer, "<<\n");
				pdf.append(pdf.buffer, "/Type /Font\n");
				pdf.append(pdf.buffer, "/Subtype /Type0\n");
				pdf.append(pdf.buffer, "/BaseFont /");
				if (name.indexOf("AdobeMingStd") == 0) {
					pdf.append(pdf.buffer, name + "-UniCNS-UTF16-H\n");
					pdf.append(pdf.buffer, "/Encoding /UniCNS-UTF16-H\n");
				} else if (name.indexOf("AdobeSongStd") == 0) {
					pdf.append(pdf.buffer, name + "-UniGB-UTF16-H\n");
					pdf.append(pdf.buffer, "/Encoding /UniGB-UTF16-H\n");
				} else if (name.indexOf("KozMinPro") == 0) {
					pdf.append(pdf.buffer, name + "-UniJIS-UCS2-H\n");
					pdf.append(pdf.buffer, "/Encoding /UniJIS-UCS2-H\n");
				} else if (name.indexOf("AdobeMyungjoStd") == 0) {
					pdf.append(pdf.buffer, name + "-UniKS-UCS2-H\n");
					pdf.append(pdf.buffer, "/Encoding /UniKS-UCS2-H\n");
				} else {
					throw new Error("Unsupported font: " + name);
				}
				pdf.append(pdf.buffer, "/DescendantFonts [");
				pdf.append(pdf.buffer, pdf.objNumber - 1);
				pdf.append(pdf.buffer, " 0 R]\n");
				pdf.append(pdf.buffer, ">>\n");
				pdf.endobj();
				objNumber = pdf.objNumber;

				ascent = size;
				descent = -ascent / 4;
				bodyHeight = ascent - descent;
			}
			pdf.fonts.push(this); 
		}

		public function setSize(fontSize : Number) : void {
			size = fontSize;
			if (isCJK) {
				ascent = size;
				descent = -ascent / 4;
				return;
			}
			ascent = bBoxURy * size / unitsPerEm;
			descent = bBoxLLy * size / unitsPerEm;
			bodyHeight = ascent - descent;
		} 
		
		public function setKernPairs(kernPairs : Boolean) : void {
       		this.kernPairs = kernPairs;
    	} 

		public function stringWidth(str : String) : Number {
			var width : int = 0;
			if (isCJK) {
				return str.length * ascent;
			}
			for (var i : Number = 0;i < str.length; i++) {
				var c1 : int = str.charCodeAt(i);
				if (isStandard == false) {
					if (c1 < firstChar || c1 > lastChar) {
						width += advanceWidths[0];
					} else {
						width += nonStandardFontGlyphWidth(c1);
					}
					continue;
				}

				if (c1 < firstChar || c1 > lastChar) {
					c1 = 32;
				}
				c1 -= 32;
				width += metrics[c1][1];

				if (kernPairs == false) continue;
				if (name.charAt(0) == "C" || name.charAt(0) == "S" || name.charAt(0) == "Z") {					
					continue;
				}

				if (i == str.length - 1) break;

				var c2 : int = str.charCodeAt(i + 1);
				if (c2 < firstChar || c2 > lastChar) {
					c2 = 32;
				}
				for (var j : Number = 2;j < metrics[c1].length; j += 2) {
					if (metrics[c1][j] == c2) {
						width += metrics[c1][j + 1];
						break;
					}
				}
			}      

			return width * size / unitsPerEm;
		}

		private function nonStandardFontGlyphWidth(c1 : int) : int {
			var width : int = 0;

			if (isComposite) {
				width = glyphWidth[c1];
			} else {
				if (c1 < 127) {
					width = glyphWidth[c1];
				} else {
					if (codePage == 0) {
						width = glyphWidth[CP1250.codes[c1 - 127]];
					} else if (codePage == 1) {
						width = glyphWidth[CP1251.codes[c1 - 127]];
					} else if (codePage == 2) {
						width = glyphWidth[CP1252.codes[c1 - 127]];
					} else if (codePage == 3) {
						width = glyphWidth[CP1253.codes[c1 - 127]];
					} else if (codePage == 4) {
						width = glyphWidth[CP1254.codes[c1 - 127]];
					} else if (codePage == 7) {
						width = glyphWidth[CP1257.codes[c1 - 127]];
					}
				}
			}

			return width;
		}
	}
}
