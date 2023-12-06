<img src="imgs/icon-tsvg.png" width="95" height="52" align="left"></img>
# Tiny SVG
A tiny SVG library for drawing and quick experiments. No dependencies. 

### Library
Add library to your project using DUB:
```
dub add tiny-svg
```

### Showcase
Here is an example of a quickly drawn Dice logo:
```d
import rk.tsvg.canvas;

auto canvas = SVGCanvas(384, 128);

// color gradient
new LinearGradient("lg0", ColorRGBA(245, 66, 233, 255), ColorRGBA(0, 208, 255, 255))
    .addToCanvas(canvas);

// dice
new Rectangle(10, 10, 100, 100)
    .setRadius(24)
    .setStrokeWidth(0)
    .setGradient("lg0")
    .addToCanvas(canvas);

// line
new Rectangle(10, canvas.height - 10, canvas.width - 20, 7)
    .setRadius(3)
    .setStrokeWidth(0)
    .setGradient("lg0")
    .addToCanvas(canvas);

// outer circle
auto circlePos = [[35, 35], [85, 35], [35, 85], [85, 85]];
foreach (pos; circlePos)
{
    new Circle(pos[0], pos[1], 13)
        .setStrokeWidth(0)
        .setFillColor(Colors.white)
        .addToCanvas(canvas);
}

// inner circle
foreach (pos; circlePos)
{
    new Circle(pos[0], pos[1], 5)
        .setStrokeWidth(1)
        .setGradient("lg0")
        .addToCanvas(canvas);
}

// text
new Text(canvas.width/3 - 10, canvas.height/3, "made with")
    .setGradient("lg0")
    .setFontSize(24)
    .setFontWeight(FontWeight.bold)
    .setFontFamily(FontFamily.luminari)
    .setStrokeWidth(0)
    .addToCanvas(canvas);

new Text(canvas.width/3 - 10, 90, "Tiny SVG")
    .setGradient("lg0")
    .setFontSize(56)
    .setFontWeight(FontWeight.bold)
    .setFontFamily(FontFamily.baskerville)
    .setStrokeWidth(1)
    .addToCanvas(canvas);

// save
canvas.save("examples/dice.svg");
```

The result:

<img src="examples/dice.svg" width="720">

### Examples
#### Origami bird
<img src="examples/origami_bird.svg" width="720">

#### Albatros
<img src="examples/albatros.svg" width="720">

Code can be found [here](source/app.d).

### LICENSE
All code is licensed under the BSL license. 

