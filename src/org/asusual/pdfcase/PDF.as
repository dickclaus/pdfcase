package org.asusual.pdfcase {
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	/**
	 * PDFcase is the library to generate PDF files on client side with the Adobe Flash Player 10.
	 * Code is base on the Java PDFjet http://pdfjet.com 
	 * 
	 * @author Dmitry Bezverkhiy
	 * @version 0.1
	 * 
	 */
	public class PDF extends Object {

		public static var useOptionalZlib : Boolean = false;

		public var buffer : ByteArray;
		public var objNumber : int = 0;
		public var fonts : Array = [];
		public var images : Array = [];
		public var pages : Array = [];
		protected var fontPath : String = "fonts";

		private var objOffset : Array = [];
		private var title : String = "";
		private var subject : String = "";
		private var author : String = "";

		// Here is the layout of the PDF document:
		//
		// Fonts
		// Images
		// Resources Object
		// Pages
		// Page1
		// Page2
		// ...
		// PageN
		// Info
		// Root
		// xref table 

		public function PDF() {
			buffer = new ByteArray();			
			append(buffer, '%PDF-1.4\n');			
			append(buffer, '%');
			buffer.writeByte(0x00F2);
			buffer.writeByte(0x00F3);
			buffer.writeByte(0x00F4);
			buffer.writeByte(0x00F5);
			buffer.writeByte(0x00F6);
			append(buffer, '\n'); 						
		}

		public function newobj() : void {
			objOffset.push(buffer.position);
			append(buffer, ++objNumber);
			append(buffer, " 0 obj\n");
		}

		public function endobj() : void {
			append(buffer, "endobj\n");
		}

		private function addResourcesObject() : int {
			newobj();
			append(buffer, "<<\n");
			append(buffer, "/ProcSet [/PDF /Text /ImageC]\n");
			append(buffer, "/Font\n");
			append(buffer, "<<\n");
			for (var i : Number = 0;i < fonts.length; i++) {
				var font : Font = fonts[i];
				append(buffer, "/F");
				append(buffer, font.objNumber);
				append(buffer, " ");
				append(buffer, font.objNumber);
				append(buffer, " 0 R\n");
			}        
			append(buffer, ">>\n");
			append(buffer, "/XObject\n");
			append(buffer, "<<\n");
			for (var j : Number = 0;j < images.length; j++) {
				var image : Image = images[j];
				append(buffer, "/Im");
				append(buffer, image.objNumber);
				append(buffer, " ");
				append(buffer, image.objNumber);
				append(buffer, " 0 R\n");
			}       
			append(buffer, ">>\n");
			append(buffer, ">>\n");
			endobj();
			return objNumber;
		}

		protected function addPagesObject() : int {
			newobj();
			append(buffer, "<<\n");
			append(buffer, "/Type /Pages\n");
			append(buffer, "/Kids [ ");
			var pageObjNumber : int = objNumber + 1;
			for (var i : Number = 0;i < pages.length; i++) {
				var page : Page = pages[i];
				append(buffer, pageObjNumber);
				append(buffer, " 0 R ");
				pageObjNumber += 3;
				pageObjNumber += page.annots.length;
			}
        
			append(buffer, "]\n");
			append(buffer, "/Count ");
			append(buffer, pages.length);
			append(buffer, '\n');
			append(buffer, ">>\n");
			endobj();
			return objNumber;
		}

		protected function addInfoObject() : int {
			// This is the info object
			newobj();
			append(buffer, "<<\n");
			append(buffer, "/Title (");
			append(buffer, title);
			append(buffer, ")\n");
			append(buffer, "/Subject (");
			append(buffer, subject);
			append(buffer, ")\n");
			append(buffer, "/Author (");
			append(buffer, author);
			append(buffer, ")\n");
			append(buffer, "/Producer (PDFpack v0.1)\n");
			var creationDate : Date = new Date();			
			append(buffer, "/CreationDate (D:");
			var date : String = creationDate.getFullYear().toString();
			date += addZero(creationDate.getMonth());
			date += addZero(creationDate.getDate());
			date += addZero(creationDate.getHours());
			date += addZero(creationDate.getMinutes());
			date += addZero(creationDate.getSeconds());
			append(buffer, date);
			append(buffer, ")\n");
			append(buffer, ">>\n");
			endobj();
			return objNumber;
			
			function addZero (num : Number) : String {
				if (num < 10) {
					return '0' + num;
				}
				return num.toString();
			} 
		}

		protected function addAllPages(pagesObjNumber : int, resObjNumber : int) : void {
			for (var i : Number = 0;i < pages.length; i++) {
				var page : Page = pages[i];
				// Page object
				newobj();
				append(buffer, "<<\n");
				append(buffer, "/Type /Page\n");
				append(buffer, "/Parent ");
				append(buffer, pagesObjNumber);
				append(buffer, " 0 R\n");
				append(buffer, "/MediaBox [0 0 ");
				append(buffer, page.width);
				append(buffer, " ");
				append(buffer, page.height);
				append(buffer, "]\n");				
				append(buffer, "/Resources ");
				append(buffer, resObjNumber);
				append(buffer, " 0 R\n");
				append(buffer, "/Contents ");
				append(buffer, (objNumber + 1));
				append(buffer, " 0 R\n");
				if (page.annots.length > 0) {
					append(buffer, "/Annots [ ");
					for (var j : Number = 0;j < page.annots.length; j++) {
						append(buffer, (objNumber + 3 + j));
						append(buffer, " 0 R ");
					}           
					append(buffer, "]\n");
				}
				append(buffer, ">>\n");
				endobj();

				// Page contents
				newobj();
				append(buffer, "<<\n");
				append(buffer, "/Filter /FlateDecode\n");
				append(buffer, "/Length ");
				append(buffer, (objNumber + 1));
				append(buffer, " 0 R\n");
				append(buffer, ">>\n");
				append(buffer, "stream\n");
				var count1 : int = buffer.position;
				page.buffer.compress();				
				buffer.writeBytes(page.buffer, 0, page.buffer.length);
				//append(buffer, page.buffer);
				var count2 : int = buffer.position;
				buffer.writeUTFBytes("\nendstream\n");
				endobj();

				// Content stream length
				newobj();
				append(buffer, (count2 - count1));
				append(buffer, '\n');
				endobj();

				addAnnotDictionaries(page);
			}
		}

		protected function addAnnotDictionaries(page : Page) : void {
			for (var i : Number = 0;i < page.annots.length; i++) {
				var annot : Annotation = page.annots[i];
				newobj();
				append(buffer, "<<\n");
				append(buffer, "/Type /Annot\n");
				append(buffer, "/Subtype /Link\n");
				append(buffer, "/Rect [");
				append(buffer, annot.x1);
				append(buffer, ' ');
				append(buffer, annot.y1);
				append(buffer, ' ');
				append(buffer, annot.x2);
				append(buffer, ' ');
				append(buffer, annot.y2);
				append(buffer, "]\n");
				append(buffer, "/Border[0 0 0]\n");
				append(buffer, "/A <<\n");
				append(buffer, "/S /URI\n");
				append(buffer, "/URI (");
				append(buffer, annot.uri);
				append(buffer, ")\n");
				append(buffer, ">>\n");
				append(buffer, ">>\n");
				endobj();
			}        
		}

		public function wrap() : void {
			var resObjNumber : int = addResourcesObject();
			var infoObjNumber : int = addInfoObject();
			var pagesObjNumber : int = addPagesObject();
			addAllPages(pagesObjNumber, resObjNumber);
			//
			// This is the root object
			newobj();
			append(buffer, "<<\n");
			append(buffer, "/Type /Catalog\n");
			append(buffer, "/Pages ");
			append(buffer, pagesObjNumber);
			append(buffer, " 0 R\n");
			// Needed by the Foxit Reader
			append(buffer, "/Base ()\n");  
			append(buffer, ">>\n");
			endobj();

			var startxref : int = buffer.position;
			// Create the xref table
			append(buffer, "xref\n");
			append(buffer, "0 ");
			append(buffer, (objNumber + 1));
			append(buffer, '\n');
			append(buffer, "0000000000 65535 f \n");
			for (var i : Number = 0;i < objOffset.length; i++) {
				var offset : int = objOffset[i];
				var str : String = String(offset);
				for (var j : Number = 0;j < 10 - str.length; j++) {
					append(buffer, '0');        		
				}
				append(buffer, str);
				append(buffer, " 00000 n \n");
			}
        
			append(buffer, "trailer\n");
			append(buffer, "<<\n");
			append(buffer, "/Size ");
			append(buffer, (objNumber + 1));
			append(buffer, '\n');
			append(buffer, "/Root ");
			append(buffer, (objNumber));
			append(buffer, " 0 R\n");
			append(buffer, "/Info ");
			append(buffer, infoObjNumber);
			append(buffer, " 0 R\n");
			append(buffer, ">>\n");
			append(buffer, "startxref\n");
			append(buffer, startxref);
			append(buffer, '\n');
			append(buffer, "%%EOF\n");
		}

		
		public function setFontPath(fontPath : String) : void {
			this.fontPath = fontPath;
		}

		
		public function setTitle(title : String) : void {
			this.title = title;
		}

		
		public function setSubject(subject : String) : void {
			this.subject = subject;
		}

		
		public function setAuthor(author : String) : void {
			this.author = author;
		}

		public function getData() : ByteArray {
			return buffer;
		} 

		public function save(fileName : String = "example.pdf") : void {
			var fileReference : FileReference = new FileReference();
			fileReference.save(buffer,fileName);			
//			var header : URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
//			var myRequest : URLRequest = new URLRequest(url + '?name=' + fileName + '&method=' + downloadMethod);
//			myRequest.requestHeaders.push(header);
//			myRequest.method = URLRequestMethod.POST;
//			myRequest.data = buffer;
//			navigateToURL(myRequest, "_blank");
		}

		public function addText(buf : ByteArray, str: String, font : Font) : void {
			append(buf, "[ (");
			var openBracket : String = '(';
			var closeBracket : String = ')';
			var slash : String = '\\';	
			for (var i : Number = 0;i < str.length; i++) {
				var c1 : int = str.charCodeAt(i);	
				//buf.writeUTFBytes(str.charAt(i));			
				if (font.isComposite) {
					if (c1 < font.firstChar || c1 > font.lastChar) {
						buf.writeByte(0x0000);
						buf.writeByte(0x0020);
						continue;
					}
					var hi : int = c1 >> 8;
					var lo : int = c1;
					
					if (hi == openBracket.charCodeAt(0) || hi == closeBracket.charCodeAt(0) || hi == slash.charCodeAt(0)) {
						buf.writeByte(slash.charCodeAt(0));
					}
					buf.writeByte(c1 >> 8);
					if (lo == openBracket.charCodeAt(0) || lo == closeBracket.charCodeAt(0) || lo == slash.charCodeAt(0)) {
						buf.writeByte(slash.charCodeAt(0));
					}
					buf.writeByte(c1);
					continue;
				}
				if (c1 < font.firstChar || c1 > font.lastChar) {
					c1 = 0x0020;
				}
	            if (c1 == openBracket.charCodeAt(0) || c1 == closeBracket.charCodeAt(0) || c1 == slash.charCodeAt(0)) {
	                buf.writeByte(slash.charCodeAt(0));
	            }
				buf.writeByte(c1);
				if (font.isStandard == false) continue;
				if (font.kernPairs == false) continue;
				if (font.name.charAt(0) == "C" || font.name.charAt(0) == "S" || font.name.charAt(0) == "Z") {					
					continue;
				}

				if (i == str.length - 1) break;
				c1 -= 32;
				var c2 : int = str.charCodeAt(i + 1);
				if (c2 < font.firstChar || c2 > font.lastChar) {
					c2 = 32;
				}
				for (var j : Number = 2;j < font.metrics[c1].length; j += 2) {
					if (font.metrics[c1][j] == c2) {
						append(buf,") ");
						append(buf,(-font.metrics[c1][j + 1]));
						append(buf," (");
						break;
					}
				}
			}
			append(buf, ") ] TJ\n"); 
		}       		

		public function append(buf : ByteArray, obj : Object) : void {
			var str : String;
			if (obj is String) {
				str = obj as String;
				writeStr(buf, str);
			}
			else if (obj is int) {
				str = (obj as int).toString();
				writeStr(buf, str);
			}
			else if (obj is Number) {
				str = (obj as Number).toString();
				writeStr(buf, str);
			}
			
			function writeStr(buff : ByteArray, st : String) : void {
				for (var i : int = 0;i < st.length; i++) {
					buff.writeUTFBytes(st.charAt(i));
				}
			}
		}
	}
}
