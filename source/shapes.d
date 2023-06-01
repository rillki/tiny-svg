module shapes;

interface Shape 
{
    void render(in string content);
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

struct Line 
{
    this(in Point p1, in Point p2) {}
}

