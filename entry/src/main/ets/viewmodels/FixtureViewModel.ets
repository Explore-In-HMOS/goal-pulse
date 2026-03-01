import { BusinessError } from '@kit.BasicServicesKit';
import { FixtureListItem } from '../models/fixtures/FixturesListItem';
import { Standing, StandingsLeague } from '../models/standing/StandingApiTypes';
import { fetchFixturesLastByLeagueSeason, fetchFixturesNextByLeagueSeason,
  fetchStandingsByLeagueSeason,
  getMainStandingsTable} from '../repository/AppRepository';
import { preferences } from '@kit.ArkData';
import { PreferencesService } from '../services/PreferencesService';
import { Constants } from '../common/utils/Constants';
import { League } from '../models/league/LeaguesApiTypes';

@Observed
export class FixturePageViewModel {
  isLoading: boolean = false;
  error: string = '';
  league: StandingsLeague | null = null;
  standings: Standing[] = [];

  lastFixtures: FixtureListItem[] = [];
  nextFixtures: FixtureListItem[] = [];

  listResetKey: number = 0;
  leagueId: number = 39;
  season: number = 2024;
  private pref: preferences.Preferences = PreferencesService.getInstance().getPref();

  init(leagueId: number, season: number): void {
    this.leagueId = leagueId;
    this.season = season;
    this.loadLast(15);
    this.loadNext(15);
    this.loadTable(season);
  }

  loadLast(last: number): void {
    this.isLoading = true;
    this.error = '';
    this.lastFixtures = [];

    fetchFixturesLastByLeagueSeason(this.leagueId, this.season, last)
      .then(list => {
        this.lastFixtures = list ?? [];
        this.listResetKey++;
      })
      .catch((e: BusinessError) => {
        this.error = e.message ?? 'Last fixtures load error';
      })
      .finally(() => {
        this.isLoading = false;
      });
  }

  loadNext(next: number): void {
    this.isLoading = true;
    this.error = '';
    this.nextFixtures = [];

    fetchFixturesNextByLeagueSeason(this.leagueId, this.season, next)
      .then(list => {
        this.nextFixtures = list ?? [];
        this.listResetKey++;
      })
      .catch((e: BusinessError) => {
        this.error = e.message ?? 'Next fixtures load error';
      })
      .finally(() => {
        this.isLoading = false;
      });
  }

  loadTable(season: number) {
    const leagueId = this.getLeague()?.id ?? 39;

    fetchStandingsByLeagueSeason(leagueId, season)
      .then(league => {
        if (league) {
          this.league = league;
          const table = getMainStandingsTable(league);
          this.standings = table;
        } else {
          this.league = null;
          this.standings = [];
        }
      })
      .catch((e: BusinessError) => {
        this.error = e.message ?? 'Next fixtures load error';
      })
      .finally(() => {
        this.isLoading = false;
      });
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
}
