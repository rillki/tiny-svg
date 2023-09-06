module rk.tsvg.filters;

import std.format : format;
import rk.tsvg.common;
import rk.tsvg.colors;

interface Filter
{
    string construct();
}

/// Empty filter
/// NOTE: use with shape.setFilter("id")
class DefaultFilter : Filter
{
    static immutable id = "__none__";
    string construct() {
        enum fmt = "<filter id='%s'><feGaussianBlur stdDeviation='0'/></filter>";
        return fmt.format(id);
    }
}

/// Gaussian blur
/// NOTE: use with shape.setFilter("id")
class Blur : Filter
{
    private immutable string id;
    private uint blurnessHorizontal = 5;
    private uint blurnessVertical = 5;

    this(in string id)
    {
        this.id = id;
    }

    this(in string id, in uint blurness)
    {
        this(id);
        this.blurnessHorizontal = this.blurnessVertical = blurness;
    }

    mixin GenerateSetters;

    string construct()
    {
        enum fmt = "<filter id='%s'><feGaussianBlur stdDeviation='%s %s'/></filter>\n";
        return fmt.format(id, blurnessHorizontal, blurnessVertical);
    }
}

/// Gaussian blur with hard edge
/// NOTE: use with shape.setFilter("id")
class BlurHardEdge : Filter
{
    private immutable string id;
    private uint blurnessHorizontal = 5;
    private uint blurnessVertical = 5;

    this(in string id)
    {
        this.id = id;
    }

    this(in string id, in uint blurness)
    {
        this(id);
        this.blurnessHorizontal = this.blurnessVertical = blurness;
    }

    mixin GenerateSetters;

    string construct()
    {
        enum fmt =
            "<filter id='%s'><feGaussianBlur stdDeviation='%s %s'/>" ~ 
            "<feComponentTransfer><feFuncA type='table' tableValues='1 1'/>" ~ 
            "</feComponentTransfer></filter>\n";
        return fmt.format(id, blurnessHorizontal, blurnessVertical);
    }
}

/// Adds shadow 
/// NOTE: use with shape.setFilter("id")
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
            "<filter id='%s' x='0' y='0' width='200%%' height='200%%'>" ~ 
            "<feOffset result='offOut' in='%s' dx='%s' dy='%s'/>" ~
            "<feGaussianBlur result='blurOut' in='offOut' stdDeviation='%s'/>" ~ 
            "<feBlend in='SourceGraphic' in2='blurOut' mode='normal'/>" ~
            "</filter>\n";
        return fmt.format(id, colorBlend ? "SourceGraphic" : "SourceAlpha", offsetX, offsetY, blurness);
    }
}

/// Linear gradient fill 
/// NOTE: use with shape.setGradient("id")
/// NOTE: to modify the angle of gradient, use `angle` and `offsetA`, `offsetB`
class LinearGradient : Filter
{
    private immutable string id;
    private ColorRGBA colorA;
    private ColorRGBA colorB;

    private int angle = 0;
    private uint offsetA = 0;
    private uint offsetB = 100;
    private float opacityA = 1;
    private float opacityB = 1;

    this(in string id, in ColorRGBA colorA, in ColorRGBA colorB)
    {
        this.id = id;
        this.colorA = colorA;
        this.colorB = colorB;
    }

    mixin GenerateSetters;

    string construct()
    {
        import std.conv : to;
        import std.math : abs, cos, sin, PI;
        import std.typecons : tuple;

        auto rotate(in int angle)
        {
            immutable rads = angle * PI / 180;
            immutable x1 = 0, y1 = 0, x2 = 100, y2 = 0;

            // find center
            immutable 
                cx = abs(x2 - x1) / 2, 
                cy = abs(y2 - y1) / 2;
            
            // translate coordinates (adjust by center)
            immutable 
                tx1 = x1 - cx, 
                ty1 = y1 - cy;
            immutable 
                tx2 = x2 - cx, 
                ty2 = y2 - cy;

            // rotate
            immutable 
                nx1 = tx1 * cos(rads) + ty1 * sin(rads) + cx,
                ny1 = -tx1 * sin(rads) + ty1 * cos(rads) + cy,
                nx2 = tx2 * cos(rads) + ty2 * sin(rads) + cx,
                ny2 = -tx2 * sin(rads) + ty2 * cos(rads) + cy;

            return tuple(nx1.to!int, ny1.to!int, nx2.to!int, ny2.to!int);
        }
        
        // rotate given an angle
        auto retp = rotate(angle);
        
        enum fmt = 
            "<linearGradient id='%s' x1='%s%%' y1='%s%%' x2='%s%%' y2='%s%%'>" ~ 
            "<stop offset='%s%%' style='stop-color:%s;stop-opacity:%s'/>" ~ 
            "<stop offset='%s%%' style='stop-color:%s;stop-opacity:%s'/>" ~ 
            "</linearGradient>\n";
        return fmt.format(id, retp.expand, offsetA, colorA.toStringRGBA, opacityA, offsetB, colorB.toStringRGBA, opacityB);
    }
}

/// Linear gradient fill 
/// NOTE: use with shape.setGradient("id")
class RadialGradient : Filter
{
    private immutable string id;
    private ColorRGBA colorA;
    private ColorRGBA colorB;
    
    private uint offsetA = 0;
    private uint offsetB = 100;
    private float opacityA = 1;
    private float opacityB = 1;

    this(in string id, in ColorRGBA colorA, in ColorRGBA colorB)
    {
        this.id = id;
        this.colorA = colorA;
        this.colorB = colorB;
    }

    mixin GenerateSetters;

    string construct()
    {
        enum fmt = 
            "<radialGradient id='%s' cx='50%%' cy='50%%' r='50%%' fx='50%%' fy='50%%'>" ~ 
            "<stop offset='%s%%' style='stop-color:%s;stop-opacity:%s'/>" ~ 
            "<stop offset='%s%%' style='stop-color:%s;stop-opacity:%s'/>" ~ 
            "</radialGradient>\n";
        return fmt.format(id, offsetA, colorA.toStringRGBA, opacityA, offsetB, colorB.toStringRGBA, opacityB);
    }
}

