module tiny_svg;

public import shapes;

struct SVGCanvas 
{
    private uint w, h;
    private string content;
    private Shape[] shapes;

    this(in uint width, in uint height) 
    {
        this.w = width;
        this.h = height;
    }

    uint width() {
        return w;
    }

    uint height() {
        return h;
    }

    void add(Shape shape) 
    {
        shapes ~= shape;
    }

    void undo() 
    {
        import std.algorithm: remove;
        if(shapes.length > 0) {
            shapes = shapes.remove(shapes.length - 1);
        }
    }

    void save(in string name) 
    {   
        import std.stdio  : File;
        import std.string : format;

        // add header
        enum fmt = "<svg width='%s px' height='%s px' xmlns='%s' version='%s' xmlns:xlink='%s'>\n";
        content = fmt.format(w, h, "http://www.w3.org/2000/svg", "1.1", "http://www.w3.org/1999/xlink");
        
        // render all shapes
        foreach(shape; shapes) {
            shape.render(content);
        }

        // save file
        File(name, "w").write(content ~ "</svg>");
    }
}


