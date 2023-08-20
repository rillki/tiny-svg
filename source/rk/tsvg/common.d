module rk.tsvg.common;

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

