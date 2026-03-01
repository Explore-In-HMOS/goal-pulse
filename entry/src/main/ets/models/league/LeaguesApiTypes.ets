export interface LeaguesApiResponse {
  response: LeagueResponseItem[]
}

export interface LeagueResponseItem {
  league: League
}

export interface League {
  id: number
  name: string
  type: string
  logo: string
}
