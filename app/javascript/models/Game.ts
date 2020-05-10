import { BankOffer } from './BankOffer';
import { Border } from './Border';
import { Corner } from './Corner';
import { DevelopmentCard, NewDevelopmentCardAction } from './DevelopmentCard';
import { Dice } from './Dice';
import { DiscardRequirement } from './DiscardRequirement';
import { Hand } from './Hand';
import { Harbor } from './Harbor';
import { Player } from './Player';
import { NewPlayerOfferAction, PlayerOffer } from './PlayerOffer';
import { Status } from './Status';
import { Territory } from './Territory';

export interface Game {
    id: number
    startedAt: string
    status: Status
    bankOffers: BankOffer[]
    playerOffers: PlayerOffer[]
    newPlayerOfferActions: NewPlayerOfferAction[]
    territories: Territory[]
    corners: Corner[]
    borders: Border[]
    harbors: Harbor[]
    players: Player[]
    hand: Hand
    developmentCards: DevelopmentCard[]
    newDevelopmentCardActions: NewDevelopmentCardAction[]
    dice: Dice
    pendingDiscardRequirement?: DiscardRequirement
}

export function gameIsStarted({ startedAt }: Game) {
    return !!startedAt
}
