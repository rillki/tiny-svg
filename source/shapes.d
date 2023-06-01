module shapes;

interface Shape 
{
    void render(ref string content);
}

enum Colors : string 
{
    white = "#FFFFFF",
    silver = "#C0C0C0",
    gray = "#808080",
    black = "#000000",
    red = "#FF0000",
    maroon = "#800000",
    yellow = "#FFFF00",
    olive = "#808000",
    lime = "#00FF00",
    green = "#008000",
    aqua = "#00FFFF",
    teal = "#008080",
    blue = "#0000FF",
    navy = "#000080",
    fuchsia = "#FF00FF",
    purple = "#800080"
}

struct Point 
{
    int x, y;
}

class Line : Shape
{
    private immutable Point p1, p2;
    private immutable Colors strokeColor;
    private immutable uint strokeWidth;

    this(in Point p1, in Point p2, in Colors strokeColor, in uint strokeWidth) 
    {
        this.p1 = p1;
        this.p2 = p2;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string content) {}
}

class Circle : Shape
{
    private immutable Point origin;
    private immutable uint radius;
    private immutable Colors fillColor;
    private immutable Colors strokeColor;
    private immutable uint strokeWidth;

    this(in Point origin, in uint radius, in Colors fillColor, in Colors strokeColor, in uint strokewidth) 
    {
        this.origin = origin;
        this.radius = radius;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string content) {}
}

class Ellipse : Shape
{
    private immutable Point origin;
    private immutable Point radius;
    private immutable Colors fillColor;
    private immutable Colors strokeColor;
    private immutable uint strokeWidth;

    this(in Point origin, in Point radius, in Colors fillColor, in Colors strokeColor, in uint strokewidth) 
    {
        this.origin = origin;
        this.radius = radius;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string content) {}
}

class Rectangle : Shape
{
    private immutable Point xy;
    private immutable Point size;
    private immutable Point radius;
    private immutable Colors fillColor;
    private immutable Colors strokeColor;
    private immutable uint strokeWidth;

    this(in Point xy, in Point size, in Point radius, in Colors fillColor, in Colors strokeColor, in uint strokewidth) 
    {
        this.xy = xy;
        this.size = size;
        this.radius = radius;
        this.fillColor = fillColor;
        this.strokeColor = strokeColor;
        this.strokeWidth = strokeWidth;
    }

    void render(ref string content) {}
}

class Text : Shape
{
    private immutable Point xy;
    private immutable string text;
    private immutable string fontFamily;
    private immutable uint fontSize;
    private immutable Colors fillColor;
    private immutable Colors strokeColor;

    this(in Point xy, in string text, in string fontFamily, in uint fontSize, in Colors fillColor, in Colors strokeColor) 
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

