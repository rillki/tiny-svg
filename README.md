<img src="imgs/icon-tsvg.png" width="95" height="52" align="left"></img>
# Tiny SVG
A tiny SVG library for drawing and quick experiments. No dependencies. 

### Library
Add library to your project using DUB:
```
dub add tiny-svg
```
Or copy the following to your DUB configuration file:
```
// dub.json
"tiny-svg": "~>1.0.0"

// dub.sdl
dependency "tiny-svg" version="~>1.0.0"
``` 

### Example
```d
import rk.tsvg.canvas;

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
```

Output:

<img src="examples/example.svg" width="240">

### Advanced example (origami bird)

<img src="examples/origami_bird.svg" width="720">

Code can be found [here](source/app.d).

### LICENSE
All code is licensed under the BSL license. 

