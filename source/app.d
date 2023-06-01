module app;

void main() 
{
	import tiny_svg;

    SVGCanvas canvas = SVGCanvas(512, 512);
    
    // draw
    canvas.drawRectangle(384, 384, 64, 64, "#00FF00", "#000000", 4, 0, 0);
    canvas.drawRectangle(320, 320, 96, 96, "#FFFF00", "#000000", 2, 8, 8);
    canvas.drawRectangle(256, 256, 128, 128, "#00FFFF", "#000000", 2, 8, 8);
    canvas.drawRectangle(192, 192, 160, 160, "#FF80FF", "#FF80FF", 2, -10, -1000);
    
    canvas.save("test.svg");
}


