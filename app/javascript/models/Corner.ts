import { Settlement } from "./Settlement";

export interface Corner {
    id: number
    x: number
    y: number
    settlement?: Settlement
}
