export enum Color {
    Blue = 'blue',
    White = 'white',
    Red = 'red',
    Orange = 'orange'
}

export function colorClassName(color: Color) {
    console.log(color)
    return color.toString()
}
