export interface TeamsApiResponse {
  response: TeamResponseItem[]
}

export interface TeamResponseItem {
  team: Team
  venue: Venue
}

export interface Team {
  id: number
  name: string
  code: string | null
  country: string | null
  founded: number | null
  national: boolean
  logo: string | null
}

export interface Venue {
  id: number
  name: string | null
  address: string | null
  city: string | null
  capacity: number | null
  surface: string | null
  image: string | null
}

export class TeamUIModel {
  id: number;
  name: string;
  code: string | null;
  country: string;
  founded: number;
  national: boolean;
  logo: string;
  venueName: string;

  constructor(
    id: number,
    name: string,
    code: string | null,
    country: string,
    founded: number,
    national: boolean,
    logo: string,
    venueName: string
  ) {
    this.id = id;
    this.name = name;
    this.code = code;
    this.country = country;
    this.founded = founded;
    this.national = national;
    this.logo = logo;
    this.venueName = venueName;
  }
}

export function toTeamUIModel(item: TeamResponseItem): TeamUIModel {
  return new TeamUIModel(
    item.team.id,
    item.team.name ?? '',
    item.team.code ?? null,
    item.team.country ?? '',
    item.team.founded ?? 0,
    item.team.national ?? false,
    item.team.logo ?? '',
    item.venue?.name ?? ''
  );
}

export function toTeamUIModels(items: TeamResponseItem[]): TeamUIModel[] {
  return items.map(toTeamUIModel);
}
