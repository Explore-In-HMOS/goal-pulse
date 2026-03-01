export interface FixturesListApiResponse {
  get: string
  parameters: FixturesListParameters
  errors: ApiErrorObject | ApiErrorObject[] | []
  results: number
  paging: Paging
  response: FixtureListItem[]
}
export interface ApiErrorObject {
  time: string
  bug: string
  report: string
}

export interface FixturesListParameters {
  league: string
  season: string
  last: string
}

export interface Paging {
  current: number
  total: number
}

export interface FixtureListItem {
  fixture: Fixture
  league: League
  teams: Teams
  goals: Goals
  score: Score
}

export interface Fixture {
  id: number
  referee: string | null
  timezone: string
  date: string // ISO string
  timestamp: number
  periods: Periods
  venue: Venue
  status: Status
}

export interface Periods {
  first: number | null
  second: number | null
}

export interface Venue {
  id: number | null
  name: string | null
  city: string | null
}

export interface Status {
  long: string
  short: string
  elapsed: number | null
  extra: number | null
}

export interface League {
  id: number
  name: string
  country: string
  logo: string
  flag: string | null
  season: number
  round: string
  standings: boolean
}

export interface Teams {
  home: TeamInfo
  away: TeamInfo
}

export interface TeamInfo {
  id: number
  name: string
  logo: string
  winner: boolean | null
}

export interface Goals {
  home: number | null
  away: number | null
}

export interface Score {
  halftime: ScorePart
  fulltime: ScorePart
  extratime: ScorePart
  penalty: ScorePart
}

export interface ScorePart {
  home: number | null
  away: number | null
}