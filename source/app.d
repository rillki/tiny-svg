// built with DMD V2.103.1
module app;

import rk.tsvg.canvas;

void main() 
{
    test_shapes();
    test_example();
    create_origami_bird();
    create_albatros();
}

void test_shapes() 
{
    SVGCanvas canvas = SVGCanvas(640, 640);

    // adding filters
    canvas.add(new Blur("blur"));
    canvas.add(new LinearGradient("red_blue_gradient", Colors.red, Colors.blue));
    canvas.add(new RadialGradient("radial_gradient", Colors.red, Colors.blue));

    // lines
    canvas.add(new Line(Point(10, 10), Point(100, 100)));
    canvas.add(
        new Line(Point(10, 30), Point(100, 120))
        .setStrokeColor(Colors.red)
        .setStrokeWidth(7)
    );
    canvas.add(
        new Line(Point(10, 60), Point(100, 180))
        .setStrokeColor(Colors.red)
        .setStrokeWidth(7)
        .setFilter("blur")
    );

    // rectangle
    canvas.add(
        new Rectangle(Point(150, 10), Point(64, 64))
        .setFillColor(Colors.teal)
    );
    canvas.add(
        new Rectangle(Point(150, 100), Point(100, 64))
        .setFillColor(Colors.green)
        .setStrokeColor(Colors.yellow)
        .setStrokeWidth(3)
    );
    canvas.add(
        new Rectangle(Point(150, 200), Point(81, 64))
        .setRadius(1)
        .setFillColor(Colors.cyan)
        .setStrokeColor(Colors.maroon)
        .setStrokeWidth(7)
    );

    // circle/ellipse
    new Circle(Point(canvas.width/2, canvas.height/2), 81)
        .setFillColor(Colors.gray)
        .setFillOpacity(1)
        .setStrokeColor(Colors.magenta)
        .setStrokeWidth(3)
        .addToCanvas(canvas);
    new Ellipse(Point(150, 350), Point(81, 64))
        .setFillColor(Colors.coral)
        .setStrokeColor(Colors.orange)
        .setStrokeWidth(2)
        .addToCanvas(canvas);
    new Circle(Point(canvas.width/2 + 100, canvas.height/2 + 100), 32)
        .setFillColor(Colors.gray)
        .setFillOpacity(1)
        .setStrokeColor(Colors.magenta)
        .setStrokeWidth(3)
        .setGradient("red_blue_gradient")
        .addToCanvas(canvas);
    new Ellipse(Point(canvas.width/2 + 110, canvas.height/2 + 180), Point(48, 32))
        .setFillColor(Colors.coral)
        .setStrokeColor(Colors.orange)
        .setStrokeWidth(2)
        .setGradient("radial_gradient")
        .addToCanvas(canvas);

    // text
    new Text(Point(150, 450), "Hello, world!")
        .setFontSize(30)
        .addToCanvas(canvas);
    new Text(Point(150, 550), "This is Tiny SVG.")
        .setFontSize(30)
        .setRotation(7)
        .setFillColor(Colors.yellow)
        .setStrokeColor(Colors.orange)
        .addToCanvas(canvas);

    // polygon/polyline
    canvas.add(
        new Polygon([Point(250, 30), Point(250, 60), Point(300, 100), Point(320, 50), Point(320, 30)])
        // new Polygon(250, 30, 250, 60, 300, 100, 320, 50, 320, 30)
            .setFillColor(Colors.lime)
            .setStrokeColor(Colors.magenta)
            .setStrokeWidth(2)
            .setFillRule(FillRule.evenodd)
    );
    canvas.add(
        new Polyline([Point(350, 50), Point(360, 90), Point(400, 70), Point(420, 120), Point(400, 30)])
            .setFillColor(Colors.lime)
            .setStrokeColor(Colors.magenta)
            .setStrokeWidth(2)
    );
    canvas.add(
        new Polyline([Point(350, 150), Point(360, 190), Point(400, 210), Point(420, 160), Point(400, 180)])
            .setFillColor(Colors.none)
            .setStrokeColor(Colors.tomato)
            .setStrokeWidth(2)
    );

    // curve
    new Curve(Point(420, 100), Point(620, 100))
        .addToCanvas(canvas);
    new Curve(Point(550, 300), Point(550, 400))
        .setStrokeWidth(3)
        .setCurveHeight(200)
        .addToCanvas(canvas);

    // path
    new Path(Point(500, 500))
        .lineTo(Point(550, 500))
        .moveTo(Point(0, 50))
        .moveTo(Point(50, 0))
        .addToCanvas(canvas);

    // translate
    canvas.translate(500, 500);
    canvas.add(new Rectangle(10, 10, 10, 10).setFillColor(Colors.gold));
    canvas.resetTranslation();
    canvas.add(new Rectangle(10, 10, 10, 10).setFillColor(Colors.gold));

    // fill
    // canvas.fill(Colors.white);

    // scale
    // canvas.scale(2);


    canvas.save("examples/test.svg");
}

void test_example()
{
    SVGCanvas canvas = SVGCanvas(240, 240);

    // create a radial gradient
    new RadialGradient("rg0", Colors.gold, Colors.orange)
        .setOpacityA(0.4)
        .setOpacityB(0.9)
        .addToCanvas(canvas);

    // draw
    new Rectangle(0, 0, canvas.width, canvas.height)
        .setStrokeColor(Colors.blue)
        .setStrokeWidth(0)
        .setRadius(24)
        .setGradient("rg0")
        .addToCanvas(canvas);
    
    new Circle(canvas.width / 3, canvas.height / 3, 24)
        .setFillColor(Colors.white)
        .addToCanvas(canvas);
    
    new Circle(canvas.width * 2 / 3, canvas.height / 3, 24)
        .setFillColor(Colors.white)
        .addToCanvas(canvas);
    
    new Curve(canvas.width / 3, canvas.height * 2 / 3, canvas.width * 2 / 3, canvas.height * 2 / 3)
        .setFillColor(Colors.white)
        .addToCanvas(canvas);

    // save
    canvas.save("examples/example.svg");
}

void create_origami_bird()
{
    auto lightBlue = ColorRGBA(129, 214, 235, 255);

    SVGCanvas canvas = SVGCanvas(1280, 720);

    // --- FILTERS, GRADIENTS
    new RadialGradient("rg0", lightBlue, lightBlue)
        .setOpacityA(0.4)
        .setOpacityB(1.0)
        .addToCanvas(canvas);
    new RadialGradient("rg1", Colors.black, Colors.black)
        .setOpacityA(0.3)
        .setOpacityB(0.1)
        .addToCanvas(canvas);
    new LinearGradient("lg0", Colors.red, Colors.orange)
        .setOpacityA(0.8)
        .addToCanvas(canvas);
    new LinearGradient("lg1", Colors.blue, Colors.cyan)
        .setOpacityA(0.8)
        .addToCanvas(canvas);
    new Blur("b0")
        .addToCanvas(canvas);

    // --- SHAPES
    
    // background
    new Rectangle(0, 0, canvas.width, canvas.height)
        .setStrokeColor(Colors.blue)
        .setStrokeWidth(0)
        .setGradient("rg0")
        .addToCanvas(canvas);
    
    // bird beak
    new Polygon([752, 341, 795, 375, 735, 375])
        .setStrokeWidth(0)
        .setGradient("lg0")
        .addToCanvas(canvas);

    // bird neck
    new Polygon([752, 341, 689, 471, 657, 370])
        .setStrokeWidth(0)
        .setGradient("lg0")
        .addToCanvas(canvas);
    
    // bird body
    new Polygon([689, 471, 548, 510, 548, 461, 580, 408, 657, 370])
        .setStrokeWidth(0)
        .setGradient("lg0")
        .addToCanvas(canvas);
    
    // bird wings
    new Polygon([657, 370, 580, 408, 632, 298])
        .setStrokeWidth(0)
        .setGradient("lg1")
        .addToCanvas(canvas);
    new Polygon([580, 408, 548, 295, 475, 294])
        .setStrokeWidth(0)
        .setGradient("lg1")
        .addToCanvas(canvas);
    new Polygon([580, 408, 632, 298, 527, 237])
        .setStrokeWidth(0)
        .setGradient("lg1")
        .addToCanvas(canvas);

    // bird tail
    new Polygon([548, 461, 548, 575, 482, 587])
        .setStrokeWidth(0)
        .setGradient("lg1")
        .addToCanvas(canvas);
    
    // shadow
    new Ellipse(canvas.width/2, 670, 120, 5)
        .setStrokeOpacity(0.05)
        .setGradient("rg1")
        .addToCanvas(canvas);

    // made with Tiny SVG
    new Text(canvas.width - 300, canvas.height - 30, "made with Tiny SVG")
        .setFillColor(Colors.white)
        .setStrokeColor(Colors.white)
        .setFontSize(29)
        .addToCanvas(canvas);

    canvas.save("examples/origami_bird.svg");
}

void create_albatros() {
    auto canvas = SVGCanvas(1024, 720);

    // GRADIENTS

    new LinearGradient("lg0", Colors.tomato, Colors.coral)
        .setOpacityA(1)
        .setOpacityB(0.9)
        .addToCanvas(canvas);
    
    new LinearGradient("lg1", Colors.orange, Colors.gold)
        .setOpacityA(1)
        .setOpacityB(0.5)
        .addToCanvas(canvas);
    
    new LinearGradient("lg2", Colors.gray, Colors.gray)
        .setOpacityA(0.75)
        .setOpacityB(0.15)
        .addToCanvas(canvas);
    
    // DRAW
    
    new Polygon([213, 262, 197, 230, 228, 230])
        .setStrokeWidth(0)
        .setGradient("lg0")
        .addToCanvas(canvas);
    
    new Polygon([213, 262, 228, 230, 243, 247, 230, 246])
        .setStrokeWidth(0)
        .setGradient("lg0")
        .addToCanvas(canvas);

    new Polygon([197, 230, 228, 199, 228, 230])
        .setStrokeWidth(0)
        .setGradient("lg0")
        .addToCanvas(canvas);
    
    new Polygon([228, 230, 228, 199, 245, 180, 261, 229])
        .setStrokeWidth(0)
        .setGradient("lg0")
        .addToCanvas(canvas);
    
    new Polygon([261, 229, 245, 180, 292, 180, 261, 229])
        .setStrokeWidth(0)
        .setGradient("lg0")
        .addToCanvas(canvas);
    
    new Polygon([228, 230, 243, 247, 266, 247, 287, 240, 292, 180, 261, 229])
        .setStrokeWidth(0)
        .setGradient("lg0")
        .addToCanvas(canvas);
    
    new Polygon([292, 180, 287, 240, 326, 228])
        .setStrokeWidth(0)
        .setGradient("lg1")
        .addToCanvas(canvas);
    
    new Polygon([326, 228, 408, 181, 292, 180])
        .setStrokeWidth(0)
        .setGradient("lg1")
        .addToCanvas(canvas);
    
    new Polygon([292, 181, 392, 132, 408, 181])
        .setStrokeWidth(0)
        .setGradient("lg1")
        .addToCanvas(canvas);
    
    new Polygon([326, 228, 392, 229, 408, 181])
        .setStrokeWidth(0)
        .setGradient("lg1")
        .addToCanvas(canvas);
    
    new Polygon([356, 175, 387, 157, 389, 167])
        .setStrokeWidth(0)
        .setFillColor(Colors.brown)
        .setFillOpacity(0.4)
        .addToCanvas(canvas);

    new Polygon([392, 132, 428, 98, 438, 132, 408, 181])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([428, 98, 438, 132, 464, 131])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([428, 98, 464, 131, 488, 66])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);

    new Polygon([488, 66, 464, 131, 532, 66])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);

    new Polygon([532, 66, 464, 131, 539, 131])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([532, 66, 539, 131, 602, 99, 569, 67])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([539, 131, 602, 99, 632, 129, 554, 146])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([554, 146, 632, 129, 603, 209])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([603, 209, 632, 129, 650, 164, 650, 199])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([603, 209, 650, 199, 603, 244])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([603, 244, 650, 199, 650, 277])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([408, 181, 438, 132, 449, 152, 470, 228])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([438, 132, 464, 131, 449, 152])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);

    new Polygon([408, 181, 392, 229, 408, 230, 440, 278, 470, 228])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([392, 229, 408, 230, 408, 260])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([408, 230, 408, 309, 440, 278])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([483, 159, 470, 228, 539, 131])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([470, 228, 539, 131, 537, 198])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([539, 131, 554, 146, 603, 209, 603, 244, 537, 198])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([470, 228, 537, 198, 507, 262])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([440, 278, 470, 228, 507, 262, 539, 294])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([507, 262, 537, 198, 539, 294])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([537, 198, 603, 244, 539, 294])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([539, 294, 603, 244, 650, 277])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);
    
    new Polygon([449, 152, 483, 159, 470, 228])
        .setStrokeWidth(0)
        .setGradient("lg2")
        .addToCanvas(canvas);

    canvas.save("examples/albatros.svg");
}

