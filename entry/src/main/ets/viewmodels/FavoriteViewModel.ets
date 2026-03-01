import { preferences } from '@kit.ArkData';
import { PreferencesService } from '../services/PreferencesService';
import { Constants } from '../common/utils/Constants';
import { TeamUIModel } from '../models/teams/TeamsApiTypes';
import { CoachResponseItem } from '../models/coach/CoachApiTypes';
import { SquadPlayer } from '../models/squads/SquadsApiTypes';
import { Standing, StandingsLeague } from '../models/standing/StandingApiTypes';
import {
  fetchCoachsByTeam,
  fetchFavTeamNewsWithPage,
  fetchSquadPlayersByTeam,
  fetchStandingsByLeagueSeason,
  getMainStandingsTable
} from '../repository/AppRepository';
import { NewsCardModel } from '../models/news/NewsApiTypes';
import { toNewsCardModel } from '../models/mappers/NewsMappers';
import { League } from '../models/league/LeaguesApiTypes';
import { BusinessError } from '@kit.BasicServicesKit';

export class FavoriteViewModel {
  team: TeamUIModel | null = null;
  coaches: CoachResponseItem[] = [];
  players: SquadPlayer[] = [];
  league: StandingsLeague | null = null;
  standings: Standing[] = [];
  standingStatistic: Standing | null = null;

  isLoading: boolean = false;
  errorMsg: string | null = null;
  pageIndex: number = 0;

  articles: NewsCardModel[] = [];
  nextPage?: string;
  hasMore: boolean = true;

  private pref: preferences.Preferences = PreferencesService.getInstance().getPref();

  init(): boolean {
    this.team = this.getTeam();
    if (!this.team) {
      this.errorMsg = 'No team selected';
      return false;
    }
    return true;
  }

  getLeague(): League | null {
    const json = this.pref.getSync(Constants.LEAGUE_KEY, '') as string;
    if (!json) {
      return null;
    }

    try {
      const obj = JSON.parse(json) as League;
      if (!obj?.id || !obj?.name) {
        return null;
      }
      return obj;
    } catch {
      return null;
    }
  }

  async loadAll(): Promise<void> {
    if (!this.team) {
      return;
    }
    await this.loadData(this.team.id);
    await this.loadNews();
  }

  async loadData(teamId: number): Promise<void> {
    this.isLoading = true;
    this.errorMsg = null;
    try {
      const coachList = await fetchCoachsByTeam(teamId);
      this.coaches = coachList ?? [];

      const leagueId = this.getLeague()?.id ?? 39;
      const league = await fetchStandingsByLeagueSeason(leagueId, 2024);
      if (league) {
        this.league = league;
        const table = getMainStandingsTable(league);
        this.standings = table;
        this.standingStatistic = table.find(s => s.team?.id === teamId) ?? null;
      } else {
        this.league = null;
        this.standings = [];
        this.standingStatistic = null;
      }

      this.players = await fetchSquadPlayersByTeam(teamId) ?? [];
    } catch (e) {
      console.error('FavoriteViewModel loadData error:', JSON.stringify(e));
      this.errorMsg = 'Load failed';
    } finally {
      this.isLoading = false;
    }
  }

  async loadNews(): Promise<void> {
    if (this.isLoading || !this.hasMore || !this.team) {
      return;
    }

    this.isLoading = true;
    try {
      const response = await fetchFavTeamNewsWithPage(this.nextPage, this.team.name);
      if (!response) {
        return;
      }

      const newItems = response.results
        .filter(item => !item.duplicate)
        .map(toNewsCardModel);

      this.articles = [...this.articles, ...newItems];
      this.nextPage = response.nextPage;
      if (!response.nextPage) {
        this.hasMore = false;
      }
    } catch (e) {
      console.error('Error', e);
    } finally {
      this.isLoading = false;
    }
  }

  setPageIndex(i: number) {
    this.pageIndex = i;
  }

  private getTeam(): TeamUIModel | null {
    const json = this.pref.getSync(Constants.TEAM_KEY, '') as string;
    if (!json) {
      return null;
    }
    try {
      const obj = JSON.parse(json) as TeamUIModel;
      if (!obj?.id || !obj?.name) {
        return null;
      }
      return obj;
    } catch {
      return null;
    }
  }
}
