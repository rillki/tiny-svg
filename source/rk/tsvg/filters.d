module rk.tsvg.filters;

import std.format : format;
import rk.tsvg.colors;

interface Filter
{
    string construct();
}

/// gaussian blur
class Blur : Filter
{
    private immutable string id;
    private uint blurnessHorizontal = 5;
    private uint blurnessVertical = 5;

    this(in string id)
    {
        this.id = id;
    }

    mixin GenerateSetters;

    string construct()
    {
        enum fmt = "<filter id='%s'><feGaussianBlur stdDeviation='%s %s'/></filter>";
        return fmt.format(id, blurnessHorizontal, blurnessVertical);
    }
}

/// gaussian blur with hard edge
class BlurHardEdge : Filter
{
    private immutable string id;
    private uint blurnessHorizontal = 5;
    private uint blurnessVertical = 5;

    this(in string id)
    {
        this.id = id;
    }

    mixin GenerateSetters;

    string construct()
    {
        enum fmt =
            "<filter id='%s'><feGaussianBlur stdDeviation='%s %s'/>" ~ 
            "<feComponentTransfer><feFuncA type='table' tableValues='1 1'/>" ~ 
            "</feComponentTransfer></filter>";
        return fmt.format(id, blurnessHorizontal, blurnessVertical);
    }
}

class Shadow : Filter 
{
    private immutable string id;
    private int offsetX = 10;
    private int offsetY = 10;
    private uint blurness = 10;
    private bool colorBlend = true;

    this(in string id)
    {
        this.id = id;
    }

    mixin GenerateSetters;

    string construct()
    {
        enum fmt = 
            "<filter id='%s' x='0' y='0' width='200%' height='200%'>" ~ 
            "<feOffset result='offOut' in='%s' dx='%s' dy='%s'/>" ~
            "<feGaussianBlur result='blurOut' in='offOut' stdDeviation='%s'/>" ~ 
            "<feBlend in='SourceGraphic' in2='blurOut' mode='normal'/>" ~
            "</filter>";
        return fmt.format(id, colorBlend ? "SourceGraphic" : "SourceAlpha", offsetX, offsetY, blurness);
    }
}

/// linear gradient fill 
/// NOTE: shape 'fill=url(#id)'
class LinearFill : Filter
{
    private immutable string id;
    private int angle = 180;
    private ColorRGBA colorA;
    private ColorRGBA colorB;
    private float opacityA = 1;
    private float opacityB = 1;

    this(in string id)
    {
        this.id = id;
    }

    mixin GenerateSetters;

    string construct()
    {
        import std.conv: to;
        import std.math: cos, sin, PI;
        
        // calculate x2, y2 given an angle
        immutable radians = angle * PI / 180;
        immutable x2 = (cos(radians) * 100).to!int;
        immutable y2 = (sin(radians) * 100).to!int;

        enum fmt = 
            "<linearGradient id='%s' x1='0%' y1='0%' x2='%s%' y2='%s%'>" ~ 
            "<stop offset='0%' style='stop-color:%s;stop-opacity:%s'/>" ~ 
            "<stop offset='100%' style='stop-color:%s;stop-opacity:%s'/>" ~ 
            "</linearGradient>";
        return fmt.format(id, x2, y2, colorA.toStringRGBA, opacityA, colorB.toStringRGBA, opacityB);
    }
}

/// generate setters for all mutable fields
mixin template GenerateSetters()
{   
    import std.string : format, toUpper;
    import std.algorithm : canFind;
    static foreach (idx, field; typeof(this).tupleof)
    {
        static if (__traits(getVisibility, field) == "private" && !typeof(field).stringof.canFind("immutable", "const"))
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

