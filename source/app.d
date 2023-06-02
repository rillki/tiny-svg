module app;

void main() 
{
	import tiny_svg;

    SVGCanvas canvas = SVGCanvas(640, 640);
    
    // draw
    canvas.add(new Line(Point(10, 10), Point(100, 100)));
    canvas.add(new Line(Point(10, 30), Point(100, 120), Colors.black, 7));
    canvas.add(new Rectangle(Point(150, 10), Point(64, 64), 0, Colors.teal));
    canvas.add(new Rectangle(Point(150, 100), Point(100, 64), 0, Colors.green, Colors.yellow, 3));
    canvas.add(new Rectangle(Point(150, 200), Point(81, 64), 1, Colors.cyan, Colors.maroon, 7));
    canvas.add(new Circle(Point(canvas.width/2, canvas.height/2), 81, Colors.gray, Colors.black, 3));
    canvas.add(new Ellipse(Point(150, 350), Point(81, 64), Colors.coral, Colors.orange, 2));
    canvas.add(new Text(Point(150, 450), "Hello, world!", "arial", 30));
    canvas.add(new Text(Point(150, 550), "This is Tiny SVG.", "arial", 30, 7, Colors.yellow, Colors.orange));
    canvas.add(new Polygon([
        Point(250, 30), Point(250, 60), Point(300, 100), Point(320, 50), Point(320, 30)
    ], Colors.lime, Colors.magenta, 2, FillRule.evenodd));

    canvas.save("test.svg");
}


