module app;

void main() 
{
	import tiny_svg;

    /** TODO:
        - lineTo
        - lineMove
     */

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
    canvas.add(new Polyline([
        Point(350, 50), Point(360, 90), Point(400, 70), Point(420, 120), Point(400, 30)
    ], Colors.lime, Colors.magenta, 2));
    canvas.add(new Polyline([
        Point(350, 150), Point(360, 190), Point(400, 210), Point(420, 160), Point(400, 180)
    ], Colors.none, Colors.tomato, 2));

    auto path = new Path(Point(500, 500))
        .lineTo(Point(550, 500))
        .moveTo(Point(0, 50))
        .moveTo(Point(50, 0));
    canvas.add(path);

    canvas.save("test.svg");
}


