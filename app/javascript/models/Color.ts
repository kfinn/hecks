export enum Color {
    Blue = 'blue',
    White = 'white',
    Red = 'red',
    Orange = 'orange'
}

export function colorClassName(color: Color) {
    return color.toString()
}
