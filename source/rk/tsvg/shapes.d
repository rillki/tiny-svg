module rk.tsvg.shapes;

import std.string : format;

interface Shape
{   
    void translate(in int x, in int y);
    void render(ref string surface);
}

struct Point
{
    int x, y;
    auto opBinary(string op)(in Point p)
    {
        static if(op == "+") return Point(x + p.x, y + p.y);
        else static if(op == "-") return Point(x - p.x, y - p.y);
        else static assert(0, "Operator '" ~ op ~ "' not supported!");
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

class Line : Shape
{
    private Point startPoint, endPoint;

    private uint strokeWidth = 1;
    private float strokeOpacity = 1;
    private ColorRGBA strokeColor = Colors.black;

    this(in Point startPoint, in Point endPoint)
    {
        this.startPoint = startPoint;
        this.endPoint = endPoint;
    }

    this(in int startX, in int startY, in int endX, in int endY) 
    {
        this(Point(startX, startY), Point(endX, endY));
    }

    mixin GenerateSetters;

    void translate(in int x, in int y)
    {
        startPoint.x += x;
        startPoint.y += y;

        endPoint.x += x;
        endPoint.y += y;
    }

    void render(ref string surface)
    {
        enum fmt = "<line x1='%s' y1='%s' x2='%s' y2='%s' style='stroke:%s;stroke-width:%s;stroke-opacity=%s'/>\n";
        surface ~= fmt.format(
            startPoint.x, startPoint.y, endPoint.x, endPoint.y, 
            strokeColor.toStringRGBA, strokeWidth, strokeOpacity
        );
    }
}

// todo
class Circle : Shape
{
    private Point origin;
    private uint radius;

    private uint strokeWidth = 1;
    private float strokeOpacity = 1;
    private ColorRGBA strokeColor = Colors.black;

    private float fillOpacity = 1;
    private ColorRGBA fillColor = Colors.none;

    this(in Point origin, in uint radius)
    {
        this.origin = origin;
        this.radius = radius;
    }

    this(in int originX, in int originY, in int radius) 
    {
        this(Point(originX, originY), radius);
    }

    mixin GenerateSetters;

    void translate(in int x, in int y)
    {
        origin.x += x;
        origin.y += y;
    }

    void render(ref string surface)
    {
        enum fmt = 
            "<circle cx='%s' cy='%s' r='%s' " ~ 
            "stroke='%s' stroke-width='%s' fill='%s' fill-opacity='%s' stroke-opacity='%s'/>\n";
        surface ~= fmt.format(
            origin.x, origin.y, radius, 
            strokeColor.toStringRGBA, strokeWidth, fillColor.toStringRGBA, fillOpacity, strokeOpacity
        );
    }
}

class Ellipse : Shape
{
    private Point origin;
    private Point radius;

    private uint strokeWidth = 1;
    private float strokeOpacity = 1;
    private ColorRGBA strokeColor = Colors.black;

    private float fillOpacity = 1;
    private ColorRGBA fillColor = Colors.none;

    this(in Point origin, in Point radius)
    {
        this.origin = origin;
        this.radius = radius;
    }

    this(in int originX, in int originY, in int radiusX, in int radiusY) 
    {
        this(Point(originX, originY), Point(radiusX, radiusY));
    }

    mixin GenerateSetters;

    void translate(in int x, in int y)
    {
        origin.x += x;
        origin.y += y;
    }

    void render(ref string surface)
    {
        enum fmt = 
            "<ellipse cx='%s' cy='%s' rx='%s' ry='%s' " ~
            "stroke='%s' stroke-width='%s' fill='%s' fill-opacity='%s' stroke-opacity='%s'/>\n";
        surface ~= fmt.format(
            origin.x, origin.y, radius.x, radius.y, 
            strokeColor.toStringRGBA, strokeWidth, fillColor.toStringRGBA, fillOpacity, strokeOpacity
        );
    }
}

class Rectangle : Shape
{
    private Point position;
    private Point size;
    
    private uint radius = 0;
    private uint strokeWidth = 1;
    private float strokeOpacity = 1;
    private ColorRGBA strokeColor = Colors.black;

    private float fillOpacity = 1;
    private ColorRGBA fillColor = Colors.none;

    this(in Point position, in Point size)
    {
        this.position = position;
        this.size = size;
    }

    this(in int x, in int y, in int width, in int height)
    {
        this(Point(x, y), Point(width, height));
    }

    mixin GenerateSetters;

    void translate(in int x, in int y)
    {
        position.x += x;
        position.y += y;
    }

    void render(ref string surface)
    {
        enum fmt = 
            "<rect x='%s' y='%s' width='%s' height='%s' rx='%s' ry='%s' " ~ 
            "fill='%s' stroke-width='%s' stroke='%s' fill-opacity='%s' stroke-opacity='%s'/>\n";
        surface ~= fmt.format(
            position.x, position.y, size.x, size.y, radius, radius, 
            fillColor.toStringRGBA, strokeWidth, strokeColor.toStringRGBA, fillOpacity, strokeOpacity
        );
    }
}

class Polygon : Shape
{
    private Point[] points; 

    private uint strokeWidth = 1;
    private float strokeOpacity = 1;
    private ColorRGBA strokeColor = Colors.black;

    private float fillOpacity = 1;
    private string fillRule = FillRule.nonzero;
    private ColorRGBA fillColor = Colors.none;

    this(Point[] points)
    {
        this.points = points;
    }

    this(in int[] coords ...) 
    in (coords.length > 0, "At least one point must be added!")
    in (coords.length % 2 == 0, "Incomplete number of points provided, must be even: (x, y) per point!") 
    {   
        import std.range: iota;
        foreach (i; iota(0, coords.length, 2)) 
        {
            import std.stdio;
            i.writeln;
            this.points ~= Point(coords[i], coords[i+1]);
        }
    }

    mixin GenerateSetters;

    void translate(in int x, in int y)
    {
        import std.parallelism: parallel;
        foreach (point; points.parallel)
        {
            point.x += x;
            point.y += y;
        }
    }

    void render(ref string surface)
    {
        enum fmt = 
            "<polygon points='%s' " ~ 
            "style='fill:%s;stroke:%s;stroke-width:%s;fill-rule:%s;fill-opacity:%s;stroke-opacity:%s;'/>";
        surface ~= fmt.format(
            points.pointsToString, 
            fillColor.toStringRGBA, strokeColor.toStringRGBA, strokeWidth, fillRule, fillOpacity, strokeOpacity
        );
    }
}

class Polyline : Shape
{
    private Point[] points; 

    private uint strokeWidth = 1;
    private float strokeOpacity = 1;
    private ColorRGBA strokeColor = Colors.black;

    private float fillOpacity = 1;
    private ColorRGBA fillColor = Colors.none;

    this(Point[] points)
    {
        this.points = points;
    }

    this(in int[] coords ...) 
    in (coords.length > 0, "At least one point must be added!")
    in (coords.length % 2 == 0, "Incomplete number of points provided, must be even: (x, y) per point!") 
    {   
        import std.range: iota;
        foreach (i; iota(0, coords.length, 2)) 
        {
            import std.stdio;
            i.writeln;
            this.points ~= Point(coords[i], coords[i+1]);
        }
    }

    mixin GenerateSetters;

    void translate(in int x, in int y)
    {
        import std.parallelism: parallel;
        foreach (point; points.parallel)
        {
            point.x += x;
            point.y += y;
        }
    }

    void render(ref string surface)
    {
        enum fmt = 
            "<polyline points='%s' " ~ 
            "style='fill:%s;stroke:%s;stroke-width:%s;fill-opacity:%s;stroke-opacity:%s;'/>";
        surface ~= fmt.format(
            points.pointsToString, 
            fillColor.toStringRGBA, strokeColor.toStringRGBA, strokeWidth, fillOpacity, strokeOpacity
        );
    }
}

class Curve : Shape 
{
    private Point start, end;
    private int curveHeight, curvature;

    private uint strokeWidth = 1;
    private float strokeOpacity = 1;
    private ColorRGBA strokeColor = Colors.black;

    private float fillOpacity = 1;
    private ColorRGBA fillColor = Colors.none;

    this(in Point start, in Point end)
    {
        this.start = start;
        this.end = Point(end.x - start.x, end.y - start.y);
        this.curveHeight = this.curvature = (this.end.x + this.end.y) / 2;
    }

    this(in int startX, in int startY, in int endX, in int endY)
    {
        this(Point(startX, startY), Point(endX, endY));
    }

    mixin GenerateSetters;

    void translate(in int x, in int y)
    {
        start.x += x;
        start.y += y;

        end.x += x;
        end.y += y;

        curveHeight += (x + y) / 2;
        curvature += (x + y) / 2;
    }

    void render(ref string surface)
    {
        enum fmt = 
            "<path d='M %s %s q %s %s %s %s' " ~ 
            "stroke='%s' stroke-width='%s' stroke-opacity='%s' fill='%s' fill-opacity='%s'/>";
        surface ~= fmt.format(
            start.x, start.y, curveHeight, curvature, end.x, end.y,
            strokeColor.toStringRGBA, strokeWidth, strokeOpacity, fillColor.toStringRGBA, fillOpacity
        );
    }
}

class Path : Shape
{   
    private Point[] points; 

    private uint strokeWidth = 1;
    private float strokeOpacity = 1;
    private ColorRGBA strokeColor = Colors.black;

    private float fillOpacity = 1;
    private ColorRGBA fillColor = Colors.none;

    this(in Point startFrom)
    {
        this.points ~= startFrom;
    }

    this(in int[] coords ...) 
    in (coords.length > 0, "At least one point must be added!")
    in (coords.length % 2 == 0, "Incomplete number of points provided, must be even: (x, y) per point!") 
    {   
        import std.range: iota;
        foreach (i; iota(0, coords.length, 2)) 
        {
            import std.stdio;
            i.writeln;
            this.points ~= Point(coords[i], coords[i+1]);
        }
    }

    mixin GenerateSetters;

    void translate(in int x, in int y)
    {
        import std.parallelism: parallel;
        foreach (point; points.parallel)
        {
            point.x += x;
            point.y += y;
        }
    }

    void render(ref string surface)
    {
        enum fmt = 
            "<polyline points='%s' " ~ 
            "style='fill:%s;stroke:%s;stroke-width:%s;fill-opacity:%s;stroke-opacity:%s;'/>";
        surface ~= fmt.format(
            points.pointsToString, 
            fillColor.toStringRGBA, strokeColor.toStringRGBA, strokeWidth, fillOpacity, strokeOpacity
        );
    }

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
}

class Text : Shape
{
    private Point xy;
    private string text;
    
    private string fontFamily = "arial";
    private uint fontSize = 10;
    private uint rotation = 0;

    private uint strokeWidth = 1;
    private float strokeOpacity = 1;
    private ColorRGBA strokeColor = Colors.black;

    private float fillOpacity = 1;
    private ColorRGBA fillColor = Colors.none;

    this(in Point xy, in string text)
    {
        this.xy = xy;
        this.text = text;
    }

    this(in int x, in int y, in string text)
    {
        this(Point(x, y), text);
    }

    mixin GenerateSetters;

    void translate(in int x, in int y)
    {
        xy.x += x;
        xy.y += y;
    }

    void render(ref string surface)
    {
        enum fmt = 
            "<text x='%s' y='%s' font-family='%s' font-size='%s' stroke='%s' stroke-width = '%s' " ~ 
            "fill='%s' fill-opacity='%s' stroke-opacity='%s' transform='rotate(%s)'>%s</text>\n";
        surface ~= fmt.format(
            xy.x, xy.y, fontFamily, fontSize, strokeColor.toStringRGBA, strokeWidth, 
            fillColor.toStringRGBA, fillOpacity, strokeOpacity, rotation, text
        );
    }
}

/// generate setters for all mutable fields
mixin template GenerateSetters()
{   
    import std.string : format, toUpper;
    import std.algorithm : canFind;
    static foreach (idx, field; typeof(this).tupleof)
    {
        static if (__traits(getVisibility, field) == "private")
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

