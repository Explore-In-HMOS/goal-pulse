import { BusinessError } from '@kit.BasicServicesKit';
import {
  FixtureDetailItem,
  FixtureTeamStatistics,
  MiniEventVM,
  StatItem,
  StatRowVM
} from '../models/fixtures/FixtureApiTypes';
import { fetchFixtureByID, fetchTeamById } from '../repository/AppRepository';
import { buildTeamCardVMs, buildTeamGoalVMs,
  buildTeamSubstVMs,
  findTeamStats,
  mergeAndSort,
  normalizeText, safeNumToText, valueByType
} from '../common/utils/HelperFunctions';
import { FixtureListItem } from '../models/fixtures/FixturesListItem';

@Observed
export class MatchStatisticsViewModel {
  isLoading: boolean = false;
  isLoadingRecent: boolean = false;
  error: string = '';
  recentError: string = '';
  fixtureId: number = 0;
  fixture: FixtureDetailItem | null = null;
  leagueName: string = '';
  venueName: string = '';
  homeLogo: string = '';
  awayLogo: string = '';
  scoreText: string = '';
  statusText: string = '';
  homeId: number = 0;
  awayId: number = 0;
  homeNameCode: string = 'N/A';
  awayNameCode: string = 'N/A';
  statRows: StatRowVM[] = [];
  homeLines: MiniEventVM[] = [];
  awayLines: MiniEventVM[] = [];
  recentFixtures: FixtureListItem[] = [];
  recentLast: number = 15;
  listResetKey: number = 0;

  init(fixtureId: number): void {
    this.fixtureId = fixtureId;
    this.loadFixture();
  }

  reload(): void {
    this.loadFixture();
  }

  reloadRecent(): void {
    const leagueId = this.fixture?.league?.id ?? 0;
    const season = this.fixture?.league?.season ?? 0;
    if (leagueId > 0 && season > 0) {
      this.loadRecentFixtures(leagueId, season, this.recentLast);
    }
  }

  private resetState(): void {
    this.error = '';
    this.fixture = null;

    this.leagueName = '';
    this.venueName = '';

    this.homeLogo = '';
    this.awayLogo = '';
    this.scoreText = '';
    this.statusText = '';

    this.homeId = 0;
    this.awayId = 0;
    this.homeNameCode = 'N/A';
    this.awayNameCode = 'N/A';

    this.statRows = [];
    this.homeLines = [];
    this.awayLines = [];

    this.recentError = '';
    this.recentFixtures = [];
  }

  private async loadFixture(): Promise<void> {
    if (this.fixtureId <= 0) {
      this.error = 'Invalid fixture id';
      return;
    }

    this.isLoading = true;
    this.resetState();

    try {
      const list = await fetchFixtureByID(this.fixtureId);

      if (!list || list.length === 0) {
        this.error = 'No fixture found';
        return;
      }

      const fx = list[0];
      this.fixture = fx;

      this.leagueName = fx.league.name;
      this.venueName = fx.fixture.venue.name ?? '';

      this.homeLogo = fx.teams.home.logo;
      this.awayLogo = fx.teams.away.logo;

      this.homeId = fx.teams.home.id;
      this.awayId = fx.teams.away.id;

      this.scoreText = `${safeNumToText(fx.goals.home)}  -  ${safeNumToText(fx.goals.away)}`;
      this.statusText = fx.fixture.status.short || '';

      this.statRows = this.buildAllStatsRows(fx.statistics ?? [], this.homeId, this.awayId);

      const events = fx.events ?? [];
      const homeGoals = buildTeamGoalVMs(events, this.homeId, 'hg');
      const awayGoals = buildTeamGoalVMs(events, this.awayId, 'ag');
      const homeCards = buildTeamCardVMs(events, this.homeId, 'hc');
      const awayCards = buildTeamCardVMs(events, this.awayId, 'ac');
      const homeSubsts = buildTeamSubstVMs(events, this.homeId, 'hs');
      const awaySubsts = buildTeamSubstVMs(events, this.awayId, 'as');

      this.homeLines = mergeAndSort(homeGoals, homeCards, homeSubsts, 'hl');
      this.awayLines = mergeAndSort(awayGoals, awayCards, awaySubsts ,'al');

      const leagueId = fx.league.id;
      const season = fx.league.season;
      if (leagueId > 0 && season > 0) {
        this.loadRecentFixtures(leagueId, season, this.recentLast);
      }

      const pair = await Promise.all([
        fetchTeamById(this.homeId).catch(() => null),
        fetchTeamById(this.awayId).catch(() => null)
      ]);

      const homeTeam = pair.length > 0 ? pair[0] : null;
      const awayTeam = pair.length > 1 ? pair[1] : null;

      this.homeNameCode = homeTeam?.code ?? 'N/A';
      this.awayNameCode = awayTeam?.code ?? 'N/A';

      this.listResetKey++;
    } catch (e) {
      const be = e as BusinessError;
      this.error = be?.message ?? 'load error';
    } finally {
      this.isLoading = false;
    }
  }

  private loadRecentFixtures(leagueId: number, season: number, last: number): void {
    if (leagueId <= 0 || season <= 0 || last <= 0) {
      return;
    }

    this.isLoadingRecent = true;
    this.recentError = '';
    this.recentFixtures = [];
  }

  private buildAllStatsRows(stats: FixtureTeamStatistics[], homeId: number, awayId: number): StatRowVM[] {
    const homeItems = findTeamStats(stats, homeId);
    const awayItems = findTeamStats(stats, awayId);

    const orderedTypes: string[] = [];
    const seen: string[] = [];

    homeItems.forEach((it: StatItem) => {
      if (seen.indexOf(it.type) === -1) {
        seen.push(it.type);
        orderedTypes.push(it.type);
      }
    });

    awayItems.forEach((it: StatItem) => {
      if (seen.indexOf(it.type) === -1) {
        seen.push(it.type);
        orderedTypes.push(it.type);
      }
    });

    const rows: StatRowVM[] = [];
    orderedTypes.forEach((t: string, idx: number) => {
      rows.push(new StatRowVM(
        `st-${idx}-${t}`,
        t,
        normalizeText(valueByType(homeItems, t)),
        normalizeText(valueByType(awayItems, t))
      ));
    });

    return rows;
  }
}
