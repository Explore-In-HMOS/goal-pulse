export interface StandingsApiResponse {
  response: StandingsResponseItem[]
}

export interface StandingsResponseItem {
  league: StandingsLeague
}

export interface StandingsLeague {
  id: number
  name: string
  country: string
  logo: string
  flag: string | null
  season: number
  standings: Standing[][]
}

export interface Standing {
  rank: number
  team: StandingTeam
  points: number
  goalsDiff: number
  group: string
  form: string | null
  status: string | null
  description: string | null
  all: StandingStats
  home: StandingStats
  away: StandingStats
  update: string
}

export interface StandingTeam {
  id: number
  name: string
  logo: string
}

export interface StandingStats {
  played: number
  win: number
  draw: number
  lose: number
  goals: StandingGoals
}

export interface StandingGoals {
  for: number
  against: number
}

export interface StandingsHeaderArgs {
  leagueName: string
}
