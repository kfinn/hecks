import React from 'react';
import { ResourceId } from '../models/Resource';
import BrickImage from '../images/brick.svg';
import GrainImage from '../images/grain.svg';
import LumberImage from '../images/lumber.svg';
import OreImage from '../images/ore.svg';
import WoolImage from '../images/wool.svg';

export function BrickIcon() {
    return <img className="hand-icon" src={BrickImage} title="Brick" />
}

export function GrainIcon() {
    return <img className="hand-icon" src={GrainImage} title="Grain" />
}

export function LumberIcon() {
    return <img className="hand-icon" src={LumberImage} title="Lumber" />
}

export function OreIcon() {
    return <img className="hand-icon" src={OreImage} title="Ore" />
}

export function WoolIcon() {
    return <img className="hand-icon" src={WoolImage} title="Wool" />
}

const RESOURCE_ICONS_BY_RESOURCE_ID = {
    [ResourceId.Brick]: BrickIcon,
    [ResourceId.Grain]: GrainIcon,
    [ResourceId.Lumber]: LumberIcon,
    [ResourceId.Ore]: OreIcon,
    [ResourceId.Wool]: WoolIcon,
}

export default function ResourceIcon({ resourceId }: { resourceId: ResourceId }) {
    const Icon = RESOURCE_ICONS_BY_RESOURCE_ID[resourceId]
    return <Icon />
}
