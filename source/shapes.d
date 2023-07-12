module shapes;

import std.string : format;

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
auto pointsToString(in Point[] points)
{
    string pts;
    foreach(point; points)
    {
        pts ~= "%s,%s ".format(point.x, point.y);
    }
    return pts;
}

struct ColorRGBA
{
    ubyte r, g, b, a;
    const toStringRGBA()
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
    none    = ColorRGBA(  0,   0,   0,   0)
}

enum FillRule : string
{
    nonzero = "nonzero",
    evenodd = "evenodd"
}

struct Appearance
{
    // stroke
    uint      strokeWidth = 1;
    float     strokeOpacity = 1;
    ColorRGBA strokeColor = Colors.black;

    // fill
    float     fillOpacity = 1;
    FillRule  fillRule = FillRule.nonzero;
    ColorRGBA fillColor = Colors.white;
}

class Line : Shape
{
    private immutable Point p1, p2;
    private uint strokeWidth = 1;
    private float strokeOpacity = 1;
    private ColorRGBA strokeColor = Colors.black;

    this(in Point p1, in Point p2)
    {
        this.p1 = p1;
        this.p2 = p2;
    }

    mixin GenerateSetters;

    void render(ref string surface)
    {
        enum fmt = "<line x1='%s' y1='%s' x2='%s' y2='%s' style='stroke:%s;stroke-width:%s;stroke-opacity=%s'/>\n";
        surface ~= fmt.format(
            p1.x, p1.y, p2.x, p2.y, 
            strokeColor.toStringRGBA, strokeWidth, strokeOpacity
        );
    }
}

// todo
class Circle : Shape
{
    private immutable Point origin;
    private immutable uint radius;
    private ColorRGBA strokeColor;
    private uint strokeWidth;
    private float strokeOpacity;
    private ColorRGBA fillColor;
    private float fillOpacity;

    this(in Point origin, in uint radius)
    {
        this.origin = origin;
        this.radius = radius;
        this.fillColor = Colors.none;
        this.fillOpacity = 1;
        this.strokeColor = Colors.black;
        this.strokeWidth = 1;
        this.strokeOpacity = 1;
    }

    mixin GenerateSetters;

    void render(ref string surface)
    {
        enum fmt = "<circle cx='%s' cy='%s' r='%s' stroke='%s' stroke-width='%s' fill='%s' fill-opacity='%s' stroke-opacity='%s'/>\n";
        surface ~= fmt.format(origin.x, origin.y, radius, strokeColor.toStringRGBA, strokeWidth, fillColor.toStringRGBA, fillOpacity, strokeOpacity);
    }
}

class Ellipse : Shape
{
    private immutable Point origin;
    private immutable Point radius;
    private ColorRGBA fillColor;
    private ColorRGBA strokeColor;
    private uint strokeWidth;
    private float strokeOpacity;
    private float fillOpacity;

    this(in Point origin, in Point radius)
    {
        this.origin = origin;
        this.radius = radius;
        this.fillColor = Colors.none;
        this.strokeColor = Colors.black;
        this.strokeWidth = 1;
        this.strokeOpacity = 1;
        this.fillOpacity = 1;
    }

    mixin GenerateSetters;

    void render(ref string surface)
    {
        enum fmt = "<ellipse cx='%s' cy='%s' rx='%s' ry='%s' stroke='%s' stroke-width='%s' fill='%s' fill-opacity='%s' stroke-opacity='%s'/>\n";
        surface ~= fmt.format(origin.x, origin.y, radius.x, radius.y, strokeColor.toStringRGBA, strokeWidth, fillColor.toStringRGBA, fillOpacity, strokeOpacity);
    }
}

class Rectangle : Shape
{
    private immutable Point xy;
    private immutable Point size;
    private ColorRGBA fillColor;
    private ColorRGBA strokeColor;
    private uint radius;
    private uint strokeWidth;
    private float strokeOpacity;
    private float fillOpacity;

    this(in Point xy, in Point size)
    {
        this.xy = xy;
        this.size = size;
        this.radius = 0;
        this.fillColor = Colors.none;
        this.strokeColor = Colors.black;
        this.strokeWidth = 1;
        this.strokeOpacity = 1;
        this.fillOpacity = 1;
    }

    mixin GenerateSetters;

    void render(ref string surface)
    {
        enum fmt = "<rect x='%s' y='%s' width='%s' height='%s' rx='%s' ry='%s' fill='%s' stroke-width='%s' stroke='%s' fill-opacity='%s' stroke-opacity='%s'/>\n";
        surface ~= fmt.format(xy.x, xy.y, size.x, size.y, radius, radius, fillColor.toStringRGBA, strokeWidth, strokeColor.toStringRGBA, fillOpacity, strokeOpacity);
    }
}

class Polygon : Shape
{
    private const Point[] points; 
    private ColorRGBA fillColor;
    private ColorRGBA strokeColor;
    private uint strokeWidth;
    private string fillRule;
    private float fillOpacity;
    private float strokeOpacity;

    this(in Point[] points)
    {
        this.points = points;
        this.fillColor = Colors.none;
        this.strokeColor = Colors.black;
        this.strokeWidth = 1;
        this.fillRule = FillRule.nonzero;
        this.fillOpacity = 1;
        this.strokeOpacity = 1;
    }

    mixin GenerateSetters;

    void render(ref string surface)
    {
        enum fmt = "<polygon points='%s' style='fill:%s;stroke:%s;stroke-width:%s;fill-rule:%s;fill-opacity:%s;stroke-opacity:%s;'/>";
        surface ~= fmt.format(points.pointsToString, fillColor.toStringRGBA, strokeColor.toStringRGBA, strokeWidth, fillRule, fillOpacity, strokeOpacity);
    }
}

class Polyline : Shape
{
    private const Point[] points; 
    private ColorRGBA fillColor;
    private ColorRGBA strokeColor;
    private uint strokeWidth;
    private float fillOpacity;
    private float strokeOpacity;

    this(in Point[] points)
    {
        this.points = points;
        this.fillColor = Colors.none;
        this.strokeColor = Colors.black;
        this.strokeWidth = 1;
        this.fillOpacity = 1;
        this.strokeOpacity = 1;
    }

    mixin GenerateSetters;

    void render(ref string surface)
    {
        enum fmt = "<polyline points='%s' style='fill:%s;stroke:%s;stroke-width:%s;fill-opacity:%s;stroke-opacity:%s;'/>";
        surface ~= fmt.format(points.pointsToString, fillColor.toStringRGBA, strokeColor.toStringRGBA, strokeWidth, fillOpacity, strokeOpacity);
    }
}

class Path : Shape
{   
    private Point[] points; 
    private ColorRGBA fillColor;
    private ColorRGBA strokeColor;
    private uint strokeWidth;
    private float fillOpacity;
    private float strokeOpacity;

    this(in Point startFrom)
    {
        this.points ~= startFrom;
        this.fillColor = Colors.none;
        this.strokeColor = Colors.black;
        this.strokeWidth = 1;
        this.fillOpacity = 1;
        this.strokeOpacity = 1;
    }

    mixin GenerateSetters;
    
    /// Draw path by setting coordinates
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
        enum fmt = "<polyline points='%s' style='fill:%s;stroke:%s;stroke-width:%s;fill-opacity:%s;stroke-opacity:%s;'/>";
        surface ~= fmt.format(points.pointsToString, fillColor.toStringRGBA, strokeColor.toStringRGBA, strokeWidth, fillOpacity, strokeOpacity);
    }
}

class Text : Shape
{
    private immutable Point xy;
    private immutable string text;
    private string fontFamily;
    private uint fontSize;
    private uint rotation;
    private ColorRGBA fillColor;
    private ColorRGBA strokeColor;
    private uint strokeWidth;
    private float fillOpacity;
    private float strokeOpacity;

    this(in Point xy, in string text)
    {
        this.xy = xy;
        this.text = text;
        this.fontFamily = "arial";
        this.fontSize = 10;
        this.rotation = 0;
        this.fillColor = Colors.none;
        this.strokeColor = Colors.black;
        this.strokeWidth = 1;
        this.fillOpacity = 1;
        this.strokeOpacity = 1;
    }

    mixin GenerateSetters;

    void render(ref string surface)
    {
        enum fmt = "<text x='%s' y='%s' font-family='%s' font-size='%s' stroke='%s' stroke-width = '%s' fill='%s' fill-opacity='%s' stroke-opacity='%s' transform='rotate(%s)'>%s</text>\n";
        surface ~= fmt.format(xy.x, xy.y, fontFamily, fontSize, strokeColor.toStringRGBA, strokeWidth, fillColor.toStringRGBA, fillOpacity, strokeOpacity, rotation, text);
    }
}

/// generate setters for all mutable fields
mixin template GenerateSetters()
{   
    import std.string : format, toUpper;
    import std.algorithm : canFind;
    static foreach(idx, field; typeof(this).tupleof)
    {
        static if(__traits(getVisibility, field) == "private" && !typeof(field).stringof.canFind("immutable", "const"))
        {
            mixin(q{
                auto set%s(typeof(this.tupleof[idx]) _)
              
              {
                    %s = _;
                    return this;
                }
            }.format(toUpper(field.stringof[0..1]) ~ field.stringof[1..$], field.stringof));
        }
    }
}

