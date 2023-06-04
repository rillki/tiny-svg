module shapes;

import std.string: format;

interface Shape
{   
    void render(ref string surface);
}

struct Point
{
    int x, y;
    auto opBinary(string op)(in Point p)
    {
        static if(op == "+") return Point(x + p.x, y + p.y);
        else static if(op == "-") return Point(x - p.x, y - p.y);
        else static assert(0, "Operator "~op~" not supported!");
    }
}

/// Converts array of coordinates to SVG points string
auto pointsToString(in Point[] points) {
    string pts;
    foreach(point; points) {
        pts ~= "%s,%s ".format(point.x, point.y);
    }
    return pts;
}

struct ColorRGBA
{
    ubyte r, g, b, a;
    immutable toStringRGB()
    {
        return "rgba(%s, %s, %s, %s)".format(r, g, b, a);
    }
}

/// encoded color codes
enum Colors : ColorRGBA
{
    black   = ColorRGBA(  0,   0,   0, 255),
    white   = ColorRGBA(255, 255, 255, 255),
    red     = ColorRGBA(255,   0,   0, 255),
    lime    = ColorRGBA(  0, 255,   0, 255),
    blue    = ColorRGBA(  0,   0, 255, 255),
    gold    = ColorRGBA(255, 215,   0, 255),
    yellow  = ColorRGBA(255, 255,   0, 255),
    orange  = ColorRGBA(255, 165,   0, 255),
    coral   = ColorRGBA(255, 127,  80, 255),
    tomato  = ColorRGBA(255,  99,  71, 255),
    cyan    = ColorRGBA(  0, 255, 255, 255),
    magenta = ColorRGBA(255,   0, 255, 255),
    silver  = ColorRGBA(192, 192, 192, 255),
    gray    = ColorRGBA(128, 128, 128, 255),
    maroon  = ColorRGBA(128,   0,   0, 255),
    olive   = ColorRGBA(128, 128,   0, 255),
    green   = ColorRGBA(  0, 128,   0, 255),
    purple  = ColorRGBA(128,   0, 128, 255),
    teal    = ColorRGBA(  0, 128, 128, 255),
    navy    = ColorRGBA(  0,   0, 128, 255),
    none    = ColorRGBA(255, 255, 255,   0)
}

enum FillRule : string {
    nonzero = "nonzero",
    evenodd = "evenodd"
}

// TODO: add opacity, stroke-opacity to every shape
class Line : Shape
{
    private immutable Point p1, p2;
    private immutable ColorRGBA strokeColor;
    private immutable uint strokeWidth;

    this(in Point p1, in Point p2, in ColorRGBA strokeColor = Colors.black, in uint strokeWidth = 1) 
    {
        this.p1 = p1;
        this.p2 = p2;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string surface)
    {
        enum fmt = "<line x1='%s' y1='%s' x2='%s' y2='%s' style='stroke:%s;stroke-width:%s'/>\n";
        surface ~= fmt.format(p1.x, p1.y, p2.x, p2.y, strokeColor.toStringRGB, strokeWidth);
    }
}

class Circle : Shape
{
    private immutable Point origin;
    private immutable uint radius;
    private immutable ColorRGBA fillColor;
    private immutable float fillOpacity;
    private immutable ColorRGBA strokeColor;
    private immutable uint strokeWidth;
    private immutable float strokeOpacity;

    this(in Point origin, in uint radius, in ColorRGBA fillColor = Colors.none, in float fillOpacity = 1, in ColorRGBA strokeColor = Colors.black, in uint strokeWidth = 1, in float strokeOpacity) 
    {
        this.origin = origin;
        this.radius = radius;
        this.fillColor = fillColor;
        this.fillOpacity = fillOpacity;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
        this.strokeOpacity = strokeOpacity;
    }

    void render(ref string surface) 
    {
        enum fmt = "<circle cx='%s' cy='%s' r='%s' stroke='%s' stroke-width='%s' fill='%s' fill-opacity='%s' stroke-opacity='%s'/>\n";
        surface ~= fmt.format(origin.x, origin.y, radius, strokeColor.toStringRGB, strokeWidth, fillColor.toStringRGB, fillOpacity, strokeOpacity);
    }
}

class Ellipse : Shape
{
    private immutable Point origin;
    private immutable Point radius;
    private immutable ColorRGBA fillColor;
    private immutable ColorRGBA strokeColor;
    private immutable uint strokeWidth;

    this(in Point origin, in Point radius, in ColorRGBA fillColor = Colors.none, in ColorRGBA strokeColor = Colors.black, in uint strokeWidth = 1) 
    {
        this.origin = origin;
        this.radius = radius;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string surface) 
    {
        enum fmt = "<ellipse cx='%s' cy='%s' rx='%s' ry='%s' stroke='%s' stroke-width='%s' fill='%s'/>\n";
        surface ~= fmt.format(origin.x, origin.y, radius.x, radius.y, strokeColor.toStringRGB, strokeWidth, fillColor.toStringRGB);
    }
}

class Rectangle : Shape
{
    private immutable Point xy;
    private immutable Point size;
    private immutable uint radius;
    private immutable ColorRGBA fillColor;
    private immutable ColorRGBA strokeColor;
    private immutable uint strokeWidth;

    this(in Point xy, in Point size, in uint radius, in ColorRGBA fillColor = Colors.none, in ColorRGBA strokeColor = Colors.black, in uint strokeWidth = 1) 
    {
        this.xy = xy;
        this.size = size;
        this.radius = radius;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string surface) 
    {
        enum fmt = "<rect x='%s' y='%s' width='%s' height='%s' rx='%s' ry='%s' fill='%s' stroke-width='%s' stroke='%s'/>\n";
        surface ~= fmt.format(xy.x, xy.y, size.x, size.y, radius, radius, fillColor.toStringRGB, strokeWidth, strokeColor.toStringRGB);
    }
}

class Polygon : Shape 
{
    private const Point[] points; 
    private immutable ColorRGBA fillColor;
    private immutable ColorRGBA strokeColor;
    private immutable uint strokeWidth;
    private immutable string fillRule;

    this(in Point[] points, in ColorRGBA fillColor = Colors.none, in ColorRGBA strokeColor = Colors.black, in uint strokeWidth = 1, in string fillRule = FillRule.nonzero)
    {
        this.points = points;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
        this.fillRule = fillRule;
    }

    void render(ref string surface) 
    {
        enum fmt = "<polygon points='%s' style='fill:%s;stroke:%s;stroke-width:%s;fill-rule:%s;'/>";
        surface ~= fmt.format(points.pointsToString, fillColor.toStringRGB, strokeColor.toStringRGB, strokeWidth, fillRule);
    }
}

class Polyline : Shape 
{
    private const Point[] points; 
    private immutable ColorRGBA fillColor;
    private immutable ColorRGBA strokeColor;
    private immutable uint strokeWidth;

    this(in Point[] points, in ColorRGBA fillColor = Colors.none, in ColorRGBA strokeColor = Colors.black, in uint strokeWidth = 1)
    {
        this.points = points;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string surface) 
    {
        enum fmt = "<polyline points='%s' style='fill:%s;stroke:%s;stroke-width:%s'/>";
        surface ~= fmt.format(points.pointsToString, fillColor.toStringRGB, strokeColor.toStringRGB, strokeWidth);
    }
}

class Path : Shape 
{   
    private Point[] points; 
    private immutable ColorRGBA fillColor;
    private immutable ColorRGBA strokeColor;
    private immutable uint strokeWidth;

    this(in Point startFrom, in ColorRGBA fillColor = Colors.none, in ColorRGBA strokeColor = Colors.black, in uint strokeWidth = 1)
    {
        this.points ~= startFrom;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }
    
    /// Draw line to coordinate
    auto lineTo(in Point point)
    {
        points ~= point;
        return this;
    }

    /// Move by amount pixels
    auto moveTo(in Point point)
    {
        points ~= points[$-1] + point;
        return this;
    }

    void render(ref string surface)
    {
        enum fmt = "<polyline points='%s' style='fill:%s;stroke:%s;stroke-width:%s'/>";
        surface ~= fmt.format(points.pointsToString, fillColor.toStringRGB, strokeColor.toStringRGB, strokeWidth);
    }
}

class Text : Shape
{
    private immutable Point xy;
    private immutable string text;
    private immutable string fontFamily;
    private immutable uint fontSize;
    private immutable uint rotate;
    private immutable ColorRGBA fillColor;
    private immutable ColorRGBA strokeColor;

    this(in Point xy, in string text, in string fontFamily, in uint fontSize, in uint rotate = 0, in ColorRGBA fillColor = Colors.black, in ColorRGBA strokeColor = Colors.black) 
    {
        this.xy = xy;
        this.text = text;
        this.fontFamily = fontFamily;
        this.fontSize = fontSize;
        this.rotate = rotate;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
    }

    void render(ref string surface) 
    {
        enum fmt = "<text x='%s' y='%s' font-family='%s' font-size='%s' stroke='%s' fill='%s' transform='rotate(%s)'>%s</text>\n";
        surface ~= fmt.format(xy.x, xy.y, fontFamily, fontSize, strokeColor.toStringRGB, fillColor.toStringRGB, rotate, text);
    }
}

