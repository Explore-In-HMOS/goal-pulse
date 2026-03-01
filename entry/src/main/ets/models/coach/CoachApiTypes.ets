export interface CoachsApiResponse {
  response: CoachResponseItem[]
}

export interface CoachResponseItem {
  id: number
  name: string
  firstname: string | null
  lastname: string | null
  age: number | null
  birth: CoachBirth
  nationality: string | null
  height: string | null
  weight: string | null
  photo: string
  team: CoachTeam
  career: CoachCareer[]
}

export interface CoachBirth {
  date: string | null
  place: string | null
  country: string | null
}

export interface CoachTeam {
  id: number
  name: string
  logo: string
}

export interface CoachCareer {
  team: CoachTeam
  start: string
  end: string | null
}
