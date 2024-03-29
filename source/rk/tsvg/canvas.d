module rk.tsvg.canvas;

public import rk.tsvg.colors;
public import rk.tsvg.shapes;
public import rk.tsvg.filters;

/// SVG canvas object
struct SVGCanvas 
{   
    private uint w, h;
    private string surface;
    private Shape[] shapes;
    private Filter[] filters;
    private int translateX = 0, translateY = 0;

    this(in uint width, in uint height) 
    {
        this.w = width;
        this.h = height;

        this.filters ~= new DefaultFilter();
    }

    uint width() 
    {
        return w;
    }

    uint height() 
    {
        return h;
    }

    /// add shape
    void add(Shape shape) 
    {
        shape.translate(translateX, translateY);
        shapes ~= shape;
    }

    /// add filter
    void add(Filter filter)
    {
        filters ~= filter;
    }

    /// undo shape operation, does not remove filters
    void undo()
    {
        import std.algorithm : remove;
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

    void scale(in float factor)
    {
        import std.parallelism : parallel;

        w.scaleBy(factor);
        h.scaleBy(factor);
        foreach (ref shape; shapes.parallel)
        {
            shape.scale(factor);
        }
    }

    void save(in string name) 
    {   
        import std.stdio  : File;
        import std.string : format;

        // add header
        enum fmt = "<svg width='%s px' height='%s px' viewBox='0 0 %s %s' xmlns='%s' version='%s' xmlns:xlink='%s'>\n";
        surface = fmt.format(w, h, w, h, "http://www.w3.org/2000/svg", "1.1", "http://www.w3.org/1999/xlink");

        // render all filters
        surface ~= "<defs>\n";
        foreach (filter; filters)
        {
            surface ~= filter.construct();
        }
        surface ~= "</defs>\n";

        // render all shapes
        foreach (shape; shapes) 
        {
            shape.render(surface);
        }

        // save file
        File(name, "w").write(surface ~ "</svg>");

        // reset
        surface = null;
    }
}

void addToCanvas(T)(T t, ref SVGCanvas canvas) 
{
    canvas.add(t);
}

