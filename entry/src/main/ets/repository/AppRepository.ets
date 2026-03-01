import { getHttp } from '../services/RcpService';
import type { League, LeaguesApiResponse } from '../models/league/LeaguesApiTypes';
import { CountriesApiResponse } from '../models/country/CountriesApiTypes';
import { Country, parseCountryList } from '../models/country/Country';
import { TeamResponseItem, TeamsApiResponse, TeamUIModel, toTeamUIModels } from '../models/teams/TeamsApiTypes';
import { CoachResponseItem, CoachsApiResponse } from '../models/coach/CoachApiTypes';
import { Standing, StandingsApiResponse, StandingsLeague } from '../models/standing/StandingApiTypes';
import { SquadApiResponse, SquadPlayer } from '../models/squads/SquadsApiTypes';
import { NewsLatestResponse } from '../models/news/NewsApiTypes';
import {
  FixturesApiResponse, LiveMatchUIModel, toLiveMatchUIModel
} from '../models/fixtures/FixturesApiTypes';
import { FixtureDetailItem, FixturesByIdApiResponse } from '../models/fixtures/FixtureApiTypes';
import { FixtureListItem, FixturesListApiResponse } from '../models/fixtures/FixturesListItem';

export async function fetchLiveMatch(
  teamId: number
): Promise<LiveMatchUIModel | undefined> {
  const raw = await getHttp(`fixtures?team=${teamId}&live=all`);
  const data = raw as FixturesApiResponse;

  if (data.results !== 0) {
    return toLiveMatchUIModel(data.response[0]);
  } else {
    return undefined;
  }
}

export async function fetchLeagues(code: string): Promise<League[]> {
  const raw = await getHttp(`leagues?code=${code}&type=league`);
  const data = raw as LeaguesApiResponse;
  const leagues = data.response.map(item => item.league);

  const map = new Map<number, League>();
  leagues.forEach(l => map.set(l.id, l));

  return Array.from(map.values());
}

export async function fetchCountries(): Promise<Country[]> {
  const raw = await getHttp('countries');
  const data = raw as CountriesApiResponse;

  return parseCountryList(data.response);
}

export async function fetchTeamsByLeagueSeason(
  leagueId: number,
  season: number
): Promise<TeamUIModel[]> {
  const raw = await getHttp(`teams?league=${leagueId}&season=${season}`);
  const data = raw as TeamsApiResponse;
  return toTeamUIModels(data.response);
}

export async function fetchCoachsByTeam(
  teamId: number
): Promise<CoachResponseItem[]> {

  const raw = await getHttp(`coachs?team=${teamId}`);
  const data = raw as CoachsApiResponse;

  if (!data.response) {
    return [];
  }

  return data.response;
}

export async function fetchStandingsByLeagueSeason(
  leagueId: number,
  season: number
): Promise<StandingsLeague | null> {
  const raw = await getHttp(`standings?league=${leagueId}&season=${season}`);
  const data = raw as StandingsApiResponse;

  if (!data.response || data.response.length === 0) {
    return null;
  }

  return data.response[0].league;
}

export function getMainStandingsTable(league: StandingsLeague): Standing[] {
  if (!league.standings || league.standings.length === 0) {
    return [];
  }
  return league.standings[0];
}

export async function fetchSquadPlayersByTeam(
  teamId: number
): Promise<SquadPlayer[]> {

  const raw = await getHttp(`players/squads?team=${teamId}`);
  const data = raw as SquadApiResponse;

  if (!data.response || data.response.length === 0) {
    return [];
  }

  return data.response[0].players;
}

export async function fetchFavTeamNewsWithPage(
  nextPage?: string,
  teamName: string = 'Real Madrid'
): Promise<NewsLatestResponse | null> {

  let endpoint =
    `api/1/latest` +
      `?apikey=${encodeURIComponent('YOUR_API_KEY_HERE')}` +
      `&qInTitle=${encodeURIComponent(teamName)}` +
      `&category=${encodeURIComponent('sports')}` +
      `&language=${encodeURIComponent('en')}`;

  if (nextPage) {
    endpoint += `&page=${encodeURIComponent(nextPage)}`;
  }

  const raw = await getHttp(endpoint, true);
  const data = raw as NewsLatestResponse;

  if (!data || data.status !== 'success' || !data.results) {
    return null;
  }

  return data;
}

export async function fetchFixtureByID(id: number): Promise<FixtureDetailItem[]> {
  try {
    const raw = await getHttp(`fixtures?id=${id}`);

    if (!raw) {
      console.error('fetchFixtureByID: raw is null/undefined');
      return [];
    }

    const data = raw as Partial<FixturesByIdApiResponse>;
    if (!Array.isArray(data.response) || data.response.length === 0) {
      console.error('fetchFixtureByID: invalid response shape', raw);
      return [];
    }

    return data.response as FixtureDetailItem[];
  } catch (e) {
    console.error('fetchFixtureByID error:', e);
    return [];
  }
}

export async function fetchTeamById(
  teamId: number
): Promise<TeamUIModel | null> {
  try {
    const raw = await getHttp(`teams?id=${teamId}`);

    if (!raw) {
      console.error('fetchTeamById: raw is null/undefined');
      return null;
    }

    const data = raw as Partial<TeamsApiResponse>;

    if (!Array.isArray(data.response) || data.response.length === 0) {
      console.error('fetchTeamById: invalid response shape', raw);
      return null;
    }

    const list = toTeamUIModels(data.response as TeamResponseItem[]);
    return list.length > 0 ? list[0] : null;

  } catch (e) {
    console.error('fetchTeamById error:', e);
    return null;
  }
}

export async function fetchFixturesLastByLeagueSeason(
  leagueId: number,
  season: number,
  last: number
): Promise<FixtureListItem[]> {

  try {
    // This endpoint need to plus version api usage
    const raw = await getHttp(
      `fixtures?league=${leagueId}&season=${season}&last=${last}`
    );

    if (!raw) {
      console.error('fetchFixturesLastByLeagueSeason: raw is null/undefined');
      return [];
    }

    const data = raw as Partial<FixturesListApiResponse>;

    if (!Array.isArray(data.response)) {
      console.error('fetchFixturesLastByLeagueSeason: invalid response shape', raw);
      return [];
    }

    return data.response as FixtureListItem[];

  } catch (e) {
    console.error('fetchFixturesLastByLeagueSeason error:', e);
    return [];
  }
}

export async function fetchFixturesByDate(
  date: string
): Promise<FixtureListItem[]> {

  try {
    const raw = await getHttp(
      `fixtures?date=${date}`
    );

    if (!raw) {
      console.error('fetchFixturesLastByLeagueSeason: raw is null/undefined');
      return [];
    }

    const data = raw as Partial<FixturesListApiResponse>;

    if (!Array.isArray(data.response) || data.response.length === 0) {
      console.error('fetchFixturesLastByLeagueSeason: invalid response shape', raw);
      return [];
    }

    return data.response as FixtureListItem[];

  } catch (e) {
    console.error('fetchFixturesLastByLeagueSeason error:', e);
    return [];
  }
}

export async function fetchFixturesNextByLeagueSeason(
  leagueId: number,
  season: number,
  next: number
): Promise<FixtureListItem[]> {

  try {
    // This endpoint need to plus version api usage
    const raw = await getHttp(
      `fixtures?league=${leagueId}&season=${season}&next=${next}`
    );

    if (!raw) {
      console.error('fetchFixturesNextByLeagueSeason: raw is null/undefined');
      return [];
    }

    const data = raw as Partial<FixturesListApiResponse>;

    if (!Array.isArray(data.response) || data.response.length === 0) {
      console.error('fetchFixturesNextByLeagueSeason: invalid response shape', raw);
      return [];
    }

    return data.response as FixtureListItem[];

  } catch (e) {
    console.error('fetchFixturesNextByLeagueSeason error:', e);
    return [];
  }
}
