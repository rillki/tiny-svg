module shapes;

import std.string: format;

interface Shape
{   
    void render(ref string content);
}

struct Point
{
    int x, y;
}

/// Converts array of coordinates to SVG points string
auto pointsToString(in Point[] points) {
    string pts;
    foreach(point; points) {
        pts ~= "%s,%s ".format(point.x, point.y);
    }
    return pts;
}

struct ColorRGB
{
    ubyte r, g, b;
    immutable toStringRGB()
    {
        return "rgb(%s, %s, %s)".format(r, g, b);
    }
}

/// encoded color codes
enum Colors : ColorRGB
{
    black   = ColorRGB(  0,   0,   0),
    white   = ColorRGB(255, 255, 255),
    red     = ColorRGB(255,   0,   0),
    lime    = ColorRGB(  0, 255,   0),
    blue    = ColorRGB(  0,   0, 255),
    gold    = ColorRGB(255, 215,   0),
    yellow  = ColorRGB(255, 255,   0),
    orange  = ColorRGB(255, 165,   0),
    coral   = ColorRGB(255, 127,  80),
    tomato  = ColorRGB(255,  99,  71),
    cyan    = ColorRGB(  0, 255, 255),
    magenta = ColorRGB(255,   0, 255),
    silver  = ColorRGB(192, 192, 192),
    gray    = ColorRGB(128, 128, 128),
    maroon  = ColorRGB(128,   0,   0),
    olive   = ColorRGB(128, 128,   0),
    green   = ColorRGB(  0, 128,   0),
    purple  = ColorRGB(128,   0, 128),
    teal    = ColorRGB(  0, 128, 128),
    navy    = ColorRGB(  0,   0, 128)
}

enum FillRule : string {
    nonzero = "nonzero",
    evenodd = "evenodd"
}

// TODO: add opacity, stroke-opacity to every shape
class Line : Shape
{
    private immutable Point p1, p2;
    private immutable ColorRGB strokeColor;
    private immutable uint strokeWidth;

    this(in Point p1, in Point p2, in ColorRGB strokeColor = Colors.black, in uint strokeWidth = 1) 
    {
        this.p1 = p1;
        this.p2 = p2;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string content)
    {
        enum fmt = "<line x1='%s' y1='%s' x2='%s' y2='%s' style='stroke:%s;stroke-width:%s'/>\n";
        content ~= fmt.format(p1.x, p1.y, p2.x, p2.y, strokeColor.toStringRGB, strokeWidth);
    }
}

class Circle : Shape
{
    private immutable Point origin;
    private immutable uint radius;
    private immutable ColorRGB fillColor;
    private immutable ColorRGB strokeColor;
    private immutable uint strokeWidth;

    this(in Point origin, in uint radius, in ColorRGB fillColor, in ColorRGB strokeColor = Colors.black, in uint strokeWidth = 1) 
    {
        this.origin = origin;
        this.radius = radius;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string content) 
    {
        enum fmt = "<circle cx='%s' cy='%s' r='%s' stroke='%s' stroke-width='%s' fill='%s'/>\n";
        content ~= fmt.format(origin.x, origin.y, radius, strokeColor.toStringRGB, strokeWidth, fillColor.toStringRGB);
    }
}

class Ellipse : Shape
{
    private immutable Point origin;
    private immutable Point radius;
    private immutable ColorRGB fillColor;
    private immutable ColorRGB strokeColor;
    private immutable uint strokeWidth;

    this(in Point origin, in Point radius, in ColorRGB fillColor, in ColorRGB strokeColor = Colors.black, in uint strokeWidth = 1) 
    {
        this.origin = origin;
        this.radius = radius;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string content) 
    {
        enum fmt = "<ellipse cx='%s' cy='%s' rx='%s' ry='%s' stroke='%s' stroke-width='%s' fill='%s'/>\n";
        content ~= fmt.format(origin.x, origin.y, radius.x, radius.y, strokeColor.toStringRGB, strokeWidth, fillColor.toStringRGB);
    }
}

class Rectangle : Shape
{
    private immutable Point xy;
    private immutable Point size;
    private immutable uint radius;
    private immutable ColorRGB fillColor;
    private immutable ColorRGB strokeColor;
    private immutable uint strokeWidth;

    this(in Point xy, in Point size, in uint radius, in ColorRGB fillColor, in ColorRGB strokeColor = Colors.black, in uint strokeWidth = 1) 
    {
        this.xy = xy;
        this.size = size;
        this.radius = radius;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string content) 
    {
        enum fmt = "<rect x='%s' y='%s' width='%s' height='%s' rx='%s' ry='%s' fill='%s' stroke-width='%s' stroke='%s'/>\n";
        content ~= fmt.format(xy.x, xy.y, size.x, size.y, radius, radius, fillColor.toStringRGB, strokeWidth, strokeColor.toStringRGB);
    }
}

class Polygon : Shape 
{
    private const Point[] points; 
    private immutable ColorRGB fillColor;
    private immutable ColorRGB strokeColor;
    private immutable uint strokeWidth;
    private immutable string fillRule;

    this(in Point[] points, in ColorRGB fillColor, in ColorRGB strokeColor = Colors.black, in uint strokeWidth = 1, in string fillRule = FillRule.nonzero)
    {
        this.points = points;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
        this.fillRule = fillRule;
    }

    void render(ref string content) {
        enum fmt = "<polygon points='%s' style='fill:%s;stroke:%s;stroke-width:%s;fill-rule:%s;'/>";
        content ~= fmt.format(points.pointsToString, fillColor.toStringRGB, strokeColor.toStringRGB, strokeWidth, fillRule);
    }
}

class Text : Shape
{
    private immutable Point xy;
    private immutable string text;
    private immutable string fontFamily;
    private immutable uint fontSize;
    private immutable uint rotate;
    private immutable ColorRGB fillColor;
    private immutable ColorRGB strokeColor;

    this(in Point xy, in string text, in string fontFamily, in uint fontSize, in uint rotate = 0, in ColorRGB fillColor = Colors.black, in ColorRGB strokeColor = Colors.black) 
    {
        this.xy = xy;
        this.text = text;
        this.fontFamily = fontFamily;
        this.fontSize = fontSize;
        this.rotate = rotate;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
    }

    void render(ref string content) 
    {
        enum fmt = "<text x='%s' y='%s' font-family='%s' font-size='%s' stroke='%s' fill='%s' transform='rotate(%s)'>%s</text>\n";
        content ~= fmt.format(xy.x, xy.y, fontFamily, fontSize, strokeColor.toStringRGB, fillColor.toStringRGB, rotate, text);
    }
}

