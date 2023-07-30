module rk.tsvg.canvas;

public import rk.tsvg.shapes;

/// SVG canvas object
struct SVGCanvas 
{   
    private immutable uint w, h;
    private string surface;
    private Shape[] shapes;
    private int translateX = 0, translateY = 0;

    this(in uint width, in uint height) 
    {
        this.w = width;
        this.h = height;
    }

    uint width() 
    {
        return w;
    }

    uint height() 
    {
        return h;
    }

    void add(Shape shape) 
    {
        shape.translate(translateX, translateY);
        shapes ~= shape;
    }

    void undo() 
    {
        import std.algorithm: remove;
        immutable len = shapes.length;
        if (len > 0) 
        {
            shapes = shapes.remove(len - 1);
        }
    }

    void translate(in int x, in int y) 
    {
        translateX += x;
        translateY += y;
    }

    void resetTranslation()
    {
        translateX = translateY = 0;
    }

    void fill(in ColorRGBA color = Colors.white)
    {
        immutable saveTranslateX = translateX;
        immutable saveTranslateY = translateY;

        this.resetTranslation();
        this.add(new Rectangle(0, 0, this.width, this.height).setStrokeWidth(0).setFillColor(color));
        this.translate(saveTranslateX, saveTranslateY);
    }

    void save(in string name) 
    {   
        import std.stdio  : File;
        import std.string : format;

        // add header
        enum fmt = "<svg width='%s px' height='%s px' xmlns='%s' version='%s' xmlns:xlink='%s'>\n";
        surface = fmt.format(w, h, "http://www.w3.org/2000/svg", "1.1", "http://www.w3.org/1999/xlink");
        surface ~= "<path d='M 200 200'/>";
        // render all shapes
        foreach (shape; shapes) 
        {
            shape.render(surface);
        }

        // save file
        File(name, "w").write(surface ~ "</svg>");
    }
}

void addToCanvas(Shape shape, ref SVGCanvas canvas) 
{
    canvas.add(shape);
}


