import { Settlement } from "./Settlement";

export enum CornerAction {
    CreateInitialSettlement = 'InitialSettlement#create',
    CreateInitialSecondSettlement = 'InitialSecondSettlement#create',
    CreateSettlementPurchase = 'SettlementPurchase#create',
    CreateCityUpgradePurchase = 'CityUpgradePurchase#create'
}

export interface Corner {
    id: number
    x: number
    y: number
    settlement?: Settlement
    cornerActions: CornerAction[]
}
