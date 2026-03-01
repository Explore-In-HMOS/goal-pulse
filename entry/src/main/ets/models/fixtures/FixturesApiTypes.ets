export interface FixturesApiResponse {
  get: string
  parameters: FixturesParameters
  errors: string[]
  results: number
  paging: Paging
  response: FixtureResponseItem[]
}

export interface FixturesParameters {
  live: string
}

export interface Paging {
  current: number
  total: number
}

export interface FixtureResponseItem {
  fixture: Fixture
  league: FixtureLeague
  teams: Teams
  goals: Goals
  score: Score
  events: Event[]
}

export interface Fixture {
  id: number
  referee: string | null
  timezone: string
  date: string
  timestamp: number
  periods: Periods
  venue: Venue
  status: Status
}

export interface Periods {
  first: number
  second: number | null
}

export interface Venue {
  id: number | null
  name: string
  city: string
}

export interface Status {
  long: string
  short: string
  elapsed: number | null
  extra: number | null
}

export interface FixtureLeague {
  id: number
  name: string
  country: string
  logo: string
  flag: string
  season: number
  round: string
  standings: boolean
}

export interface Teams {
  home: Team
  away: Team
}

export interface Team {
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
  halftime: ScoreDetail
  fulltime: ScoreDetail
  extratime: ScoreDetail
  penalty: ScoreDetail
}

export interface ScoreDetail {
  home: number | null
  away: number | null
}

export interface Event {
  time: EventTime
  team: EventTeam
  player: EventPlayer
  assist: EventAssist
  type: string
  detail: string
  comments: string | null
}

export interface EventTime {
  elapsed: number
  extra: number | null
}

export interface EventTeam {
  id: number
  name: string
  logo: string
}

export interface EventPlayer {
  id: number | null
  name: string | null
}

export interface EventAssist {
  id: number | null
  name: string | null
}

export class LiveMatchUIModel {
  homeTeamId: number
  homeTeamGoals: number
  homeTeamName: string
  homeTeamLogo: string
  awayTeamId: number
  awayTeamGoals: number
  awayTeamName: string
  awayTeamLogo: string
  events: Event[]
  elapsed: number

  constructor(
    homeTeamId: number,
    homeTeamGoals: number,
    homeTeamName: string,
    homeTeamLogo: string,
    awayTeamId: number,
    awayTeamGoals: number,
    awayTeamName: string,
    awayTeamLogo: string,
    events: Event[],
    elapsed: number
  ) {
    this.homeTeamId = homeTeamId
    this.homeTeamGoals = homeTeamGoals
    this.homeTeamName = homeTeamName
    this.homeTeamLogo = homeTeamLogo
    this.awayTeamId = awayTeamId
    this.awayTeamGoals = awayTeamGoals
    this.awayTeamName = awayTeamName
    this.awayTeamLogo = awayTeamLogo
    this.events = events
    this.elapsed = elapsed
  }
}

export function toLiveMatchUIModel(item: FixtureResponseItem): LiveMatchUIModel {
  return new LiveMatchUIModel(
    item.teams.home.id,
    item.goals.home ?? 0,
    item.teams.home.name ?? '',
    item.teams.home.logo ?? '',
    item.teams.away.id,
    item.goals.away ?? 0,
    item.teams.away.name ?? '',
    item.teams.away.logo ?? '',
    item.events,
    item.fixture.status.elapsed ?? 0,
  )
}

export function toLiveMatchUIModels(items: FixtureResponseItem[]): LiveMatchUIModel[] {
  return items.map(toLiveMatchUIModel)
}