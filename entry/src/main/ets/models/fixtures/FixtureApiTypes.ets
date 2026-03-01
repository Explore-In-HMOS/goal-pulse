// ---------- ROOT ----------
export interface FixturesByIdApiResponse {
  get: string
  parameters: FixturesByIdParameters
  errors: ApiErrorObject | ApiErrorObject[] | []
  results: number
  paging: Paging
  response: FixtureDetailItem[]
}

export interface FixturesByIdParameters {
  id: string
}

export interface Paging {
  current: number
  total: number
}

export interface ApiErrorObject {
  time: string
  bug: string
  report: string
}

// ---------- ITEM ----------
export interface FixtureDetailItem {
  fixture: Fixture
  league: League
  teams: Teams
  goals: Goals
  score: Score
  events: FixtureEvent[]
  statistics: FixtureTeamStatistics[]
}

// ---------- COMMON BLOCKS ----------
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

// ---------- EVENTS ----------
export interface FixtureEvent {
  time: EventTime
  team: EventTeam
  player: EventPerson
  assist: EventPerson
  type: string
  detail: string
  comments: string | null
}

export interface EventTime {
  elapsed: number | null
  extra: number | null
}

export interface EventTeam {
  id: number | null
  name: string | null
  logo: string | null
}

export interface EventPerson {
  id: number | null
  name: string | null
}

// ---------- STATISTICS ----------
export interface FixtureTeamStatistics {
  team: StatTeam
  statistics: StatItem[]
}

export interface StatTeam {
  id: number | null
  name: string | null
  logo: string | null
}

export interface StatItem {
  type: string
  value: number | string | null
}

export class MiniEventVM {
  key: string;
  minuteNum: number;
  minute: string;
  icon: string;
  who: string;

  constructor(key: string, minuteNum: number, minute: string, icon: string, who: string) {
    this.key = key;
    this.minuteNum = minuteNum;
    this.minute = minute;
    this.icon = icon;
    this.who = who;
  }
}

export class StatRowVM {
  key: string;
  label: string;
  left: string;
  right: string;

  constructor(key: string, label: string, left: string, right: string) {
    this.key = key;
    this.label = label;
    this.left = left;
    this.right = right;
  }
}
