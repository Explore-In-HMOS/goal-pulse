export enum PlayerPosition {
  Goalkeeper = 'Goalkeeper',
  Defender = 'Defender',
  Midfielder = 'Midfielder',
  Attacker = 'Attacker',
  Unknown = 'Unknown'
}

export function playerPosition(position: string): string {
  switch (position) {
    case PlayerPosition.Goalkeeper:
      return 'GK';
    case PlayerPosition.Defender:
      return 'DEF';
    case PlayerPosition.Midfielder:
      return 'MID';
    case PlayerPosition.Attacker:
      return 'FWD';
    default:
      return 'UNK';
  }
}