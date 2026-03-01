export interface SquadApiResponse {
  response: SquadResponseItem[]
}

export interface SquadResponseItem {
  team: SquadTeam
  players: SquadPlayer[]
}

export interface SquadTeam {
  id: number
  name: string
  logo: string
}

export interface SquadPlayer {
  id: number
  name: string
  age: number
  number: number | null
  position: string
  photo: string
}

