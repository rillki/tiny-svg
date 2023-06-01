module shapes;

import std.string: format;

interface Shape 
{
    void render(ref string content);
}

/// ditto
struct Point 
{
    int x, y;
}

/// RGB
struct Color
{
    ubyte r, g, b;
    immutable toStringRGB()
    {
        return "rgb(%s, %s, %s)".format(r, g, b);
    }
}

/// encoded color codes
enum Colors : Color
{
    black = Color(0, 0, 0),
    white = Color(255, 255, 255),
    red = Color(255, 0, 0),
    lime = Color(0, 255, 0),
    blue = Color(0, 0, 255),
    yellow = Color(255, 255, 0),
    cyan = Color(0, 255, 255),
    magenta = Color(255, 0, 255),
    silver = Color(192, 192, 192),
    gray = Color(128, 128, 128),
    maroon = Color(128, 0, 0),
    olive = Color(128, 128, 0),
    green = Color(0, 128, 0),
    purple = Color(128, 0, 128),
    teal = Color(0, 128, 128),
    navy = Color(0, 0, 128)
}

class Line : Shape
{
    private immutable Point p1, p2;
    private immutable Color strokeColor;
    private immutable uint strokeWidth;

    this(in Point p1, in Point p2, in Color strokeColor, in uint strokeWidth) 
    {
        this.p1 = p1;
        this.p2 = p2;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string content)
    {
        enum fmt = "<line x1='%s' y1='%s' x2='%s' y2='%s' style='stroke:%s;stroke-width:%s'/>";
        content ~= fmt.format(p1.x, p1.y, p2.x, p2.y, strokeColor.toStringRGB, strokeWidth);
    }
}

class Circle : Shape
{
    private immutable Point origin;
    private immutable uint radius;
    private immutable Color fillColor;
    private immutable Color strokeColor;
    private immutable uint strokeWidth;

    this(in Point origin, in uint radius, in Color fillColor, in Color strokeColor, in uint strokewidth) 
    {
        this.origin = origin;
        this.radius = radius;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string content) 
    {
        enum fmt = "<circle cx='%s' cy='%s' r='%s' stroke='%s' stroke-width='%s' fill='%s'/>";
        content ~= fmt.format(origin.x, origin.y, radius, strokeColor.toStringRGB, strokeWidth, fillColor);
    }
}

class Ellipse : Shape
{
    private immutable Point origin;
    private immutable Point radius;
    private immutable Color fillColor;
    private immutable Color strokeColor;
    private immutable uint strokeWidth;

    this(in Point origin, in Point radius, in Color fillColor, in Color strokeColor, in uint strokewidth) 
    {
        this.origin = origin;
        this.radius = radius;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string content) 
    {
        enum fmt = "<circle cx='%s' cy='%s' rx='%s' rx='%s' stroke='%s' stroke-width='%s' fill='%s'/>";
        content ~= fmt.format(origin.x, origin.y, radius.x, radius.y, strokeColor.toStringRGB, strokeWidth, fillColor);
    }
}

class Rectangle : Shape
{
    private immutable Point xy;
    private immutable Point size;
    private immutable Point radius;
    private immutable Color fillColor;
    private immutable Color strokeColor;
    private immutable uint strokeWidth;

    this(in Point xy, in Point size, in Point radius, in Color fillColor, in Color strokeColor, in uint strokewidth) 
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
        // TODO
    }
}

class Text : Shape
{
    private immutable Point xy;
    private immutable string text;
    private immutable string fontFamily;
    private immutable uint fontSize;
    private immutable Color fillColor;
    private immutable Color strokeColor;

    this(in Point xy, in string text, in string fontFamily, in uint fontSize, in Color fillColor, in Color strokeColor) 
    {
        this.xy = xy;
        this.text = text;
        this.fontFamily = fontFamily;
        this.fontSize = fontSize;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
    }

    void render(ref string content) {}
}

