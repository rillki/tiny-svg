module rk.tsvg.colors;

import std.format : format;

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

