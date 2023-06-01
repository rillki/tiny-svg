module tiny_svg;

import std.string: format;

struct SVGCanvas 
{
    private uint width, height;
    private string content;

    this(in uint width, in uint height) 
    {
        this.width = width;
        this.height = height;

        content = "<svg width='%s px' height='%s px' xmlns='%s' version='%s' xmlns:xlink='%s'>\n"
            .format(width, height, "http://www.w3.org/2000/svg", "1.1", "http://www.w3.org/1999/xlink");
    }

    void drawRectangle(
        in int width, in int height, 
        in int x, in int y, 
        in string fill, in string stroke, 
        in int strokewidth, in int radiusx, in int radiusy
    ) {
        content ~= (
            "<rect fill='%s' stroke='%s' " ~
            "stroke-width='%s px' width='%s' height='%s' " ~
            "y='%s' x='%s' ry='%s' rx='%s'/>\n"
        ).format(
            fill, stroke, 
            strokewidth, width, height,
            y, x, radiusy, radiusx
        );
    }

    void save(in string name) {
        import std.stdio: File;
        File(name, "w").write(content ~ "</svg>");
    }
}


