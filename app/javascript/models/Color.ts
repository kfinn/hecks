export enum Color {
    Blue = 'blue',
    White = 'white',
    Red = 'red',
    Orange = 'orange',
    Teal = 'teal',
    Brown = 'brown',
    Pink = 'pink'
}

export function colorClassName(color: Color) {
    return color.toString()
}
