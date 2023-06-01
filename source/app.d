module app;

void main() 
{
	import tiny_svg;

    SVGCanvas canvas = SVGCanvas(512, 512);
    
    // draw
    // ...
        
    canvas.save("test.svg");
}


