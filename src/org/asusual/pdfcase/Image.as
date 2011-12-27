package org.asusual.pdfcase {
	import org.bytearray.images.JPEGEncoder;

	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	/**
	 * PDFcase is the library to generate PDF files on client side with the Adobe Flash Player 10.
	 * Code is base on the Java PDFjet http://pdfjet.com 
	 * 
	 * @author Dmitry Bezverkhiy
	 * @version 0.1
	 * 
	 */
	public class Image extends Object {
		protected var name : String = '';
		public var objNumber : int = 0;
		// Position of the image on the page
		protected var x : Number = 0.0;   		
		protected var y : Number = 0.0;
		// Image width
		protected var w : Number = 0.0;   
		// Image height
		protected var h : Number = 0.0;   
		
		private var boxX : Number = 0.0;
		private var boxY : Number = 0.0;
		private var jpgImage : Boolean = false;
		private var data : ByteArray;
		private var dataSize : Number = 0;

		public function Image(pdf : PDF, image : BitmapData, filename : String = 'image.jpg') {
			data = new ByteArray();
			name = filename;
			if (image != null) {
	            if (name.indexOf(".jpg") == filename.length-4) {
	            		w = image.width;
	            		h = image.height;
	            		var encoder : JPEGEncoder = new JPEGEncoder(90);
	            		var by : ByteArray  = new ByteArray;	            		
	            		by = encoder.encode(image);	            		
	                    jpgImage = true;	                    
	                    data.writeBytes(by,0,by.length);
	            } 
	            else {
	                extractAndCompressImage(image);
	            }
	        } 
	        else {	        	
	            w = 32;
	            h = 32;
	            var miss : ByteArray = new ByteArray();
	            for (var i : int = 0; i < Missing.image.length; i++) {
	            	var byte : int = Missing.image[i];
	            	miss.writeByte(byte);
				}
	            data.writeBytes(miss, 0, miss.length);	
	            dataSize = data.length;            
	        }
	
	        addThisImageTo(pdf, dataSize); 
		}
		
		public function setPosition(x : Number, y : Number) : void {
        	this.x = x;
        	this.y = y;
    	}

    	public function scaleBy(factor : Number) : void {
        	this.w *= factor;
        	this.h *= factor;
    	}

    	public function placeIn(box : Box) : void {
        	boxX = box.x;
        	boxY = box.y;
    	}

	    public function drawOn(page : Page) : void {
	        x += boxX;
	        y += boxY;
	        page.pdf.append(page.buffer, "q\n");
	        page.pdf.append(page.buffer, w);
	        page.pdf.append(page.buffer, " 0 0 ");
	        page.pdf.append(page.buffer, h);
	        page.pdf.append(page.buffer, ' ');
	        page.pdf.append(page.buffer, x);
	        page.pdf.append(page.buffer, ' ');
	        page.pdf.append(page.buffer, (page.height - y) - h);
	        page.pdf.append(page.buffer, " cm\n");
	        page.pdf.append(page.buffer, "/Im");
	        page.pdf.append(page.buffer, objNumber);
	        page.pdf.append(page.buffer, " Do\n");
	        page.pdf.append(page.buffer, "Q\n");
	    } 
	    
	    private function extractAndCompressImage(image : BitmapData) : void {
	        w = image.width;
	        h = image.height;
	        var by : ByteArray = new ByteArray();	              
	        for (var y : int = 0;y < h; y++) {
	        	for (var x : int = 0; x < w; x++) {
	        		var pixel : uint = image.getPixel32(x, y);	        		
	        		by.writeByte(pixel >> 16);
	        		by.writeByte(pixel >> 8);
	        		by.writeByte(pixel);
	        	}	        	
			}
	        by.compress();
	        data.writeBytes(by,0,by.length);	        
			dataSize = data.length;
    	} 
    	
    	private function addThisImageTo(pdf : PDF, dataSize : Number) : void {
	        // Add the image	       
	        pdf.newobj();
	        pdf.append(pdf.buffer, "<<\n");
	        pdf.append(pdf.buffer, "/Type /XObject\n");
	        pdf.append(pdf.buffer, "/Subtype /Image\n");
	        if (jpgImage) {
	            pdf.append(pdf.buffer, "/Filter /DCTDecode\n");
	        } else {
	            pdf.append(pdf.buffer, "/Filter /FlateDecode\n");
	        }
	        pdf.append(pdf.buffer, "/Width ");
	        pdf.append(pdf.buffer, w);
	        pdf.append(pdf.buffer, '\n');
	        pdf.append(pdf.buffer, "/Height ");
	        pdf.append(pdf.buffer, h);
	        pdf.append(pdf.buffer, '\n');
	        pdf.append(pdf.buffer, "/ColorSpace /DeviceRGB\n");
	        pdf.append(pdf.buffer, "/BitsPerComponent 8\n");
	        pdf.append(pdf.buffer, "/Length ");
	        pdf.append(pdf.buffer, dataSize);
	        pdf.append(pdf.buffer, '\n');
	        pdf.append(pdf.buffer, ">>\n");
	        pdf.append(pdf.buffer, "stream\n");
	        pdf.buffer.writeBytes(data, 0, dataSize);	        
	        pdf.append(pdf.buffer, "\nendstream\n");
	        pdf.endobj();
	        pdf.images.push(this);
	        objNumber = pdf.objNumber;
    	} 
		
	}
}
