module tiny_svg;

public import shapes;

struct SVGCanvas 
{
    private uint width, height;
    private string content;
    private Shape[] shapes;

    this(in uint width, in uint height) 
    {
        this.width = width;
        this.height = height;
    }

    void add() {}
    void undo() {}
    void scale() {}

    void save(in string name) 
    {   
        import std.stdio  : File;
        import std.string : format;

        // add header
        content = "<svg width='%s px' height='%s px' xmlns='%s' version='%s' xmlns:xlink='%s'>\n"
            .format(width, height, "http://www.w3.org/2000/svg", "1.1", "http://www.w3.org/1999/xlink");
        
        // render all shapes
        // ...

        // save file
        File(name, "w").write(content ~ "</svg>");
    }
}


