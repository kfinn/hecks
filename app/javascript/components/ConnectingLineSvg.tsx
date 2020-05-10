import React from 'react';
import { Position } from '../models/Position';
import { territoryCenterX, territoryCenterY } from './TerritorySvg';

interface ConnectingLineSvgProps {
    from: Position
    fromMargin?: number
    to: Position
    toMargin?: number
    strokeWidth?: number
    onClick?: () => void
    className?: string
}

export default function ConnectingLineSvg({ from, fromMargin = 10, to, toMargin = 10, strokeWidth = 4, ...otherProps }: ConnectingLineSvgProps) {
    const fromX = territoryCenterX(from)
    const fromY = territoryCenterY(from)
    const toX = territoryCenterX(to)
    const toY = territoryCenterY(to)

    const dx = toX - fromX
    const dy = toY - fromY
    const totalDistance = Math.sqrt((dx * dx) + (dy * dy))
    const distance = totalDistance - (fromMargin + toMargin)
    const rotationRadians = Math.atan2(dx, dy)

    const halfStrokeWidth = strokeWidth / 2

    return <path
        d={`
            M${fromX} ${fromY}
            m${Math.sin(rotationRadians) * fromMargin} ${Math.cos(rotationRadians) * fromMargin}
            l${Math.sin(rotationRadians + (Math.PI / 2)) * halfStrokeWidth} ${Math.cos(rotationRadians + (Math.PI / 2)) * halfStrokeWidth}
            l${Math.sin(rotationRadians) * (distance)} ${Math.cos(rotationRadians) * (distance)}
            l${Math.sin(rotationRadians + (Math.PI / 2)) * (-strokeWidth)} ${Math.cos(rotationRadians + (Math.PI / 2)) * (-strokeWidth)}
            l${Math.sin(rotationRadians) * (-(distance))} ${Math.cos(rotationRadians) * (-(distance))}
            z
        `}
        {...otherProps}
    />
}
