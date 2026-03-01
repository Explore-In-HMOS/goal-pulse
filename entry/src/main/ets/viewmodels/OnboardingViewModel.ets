import { BusinessError } from '@kit.BasicServicesKit';
import { fetchCountries, fetchLeagues, fetchTeamsByLeagueSeason } from '../repository/AppRepository';
import type { Country } from '../models/country/Country';
import type { League } from '../models/league/LeaguesApiTypes';
import type { Team, TeamUIModel } from '../models/teams/TeamsApiTypes';
import { Mode } from '../models/enums/EnumMode';
import { PreferencesService } from '../services/PreferencesService';
import { NavigationService } from '../services/NavigationService';
import { Constants } from '../common/utils/Constants';
import { preferences } from '@kit.ArkData';

@Observed
export class OnboardingViewModel {
  mode: Mode = Mode.Country;
  countries: Country[] = [];
  leagues: League[] = [];
  teams: TeamUIModel[] = [];
  isLoading: boolean = false;
  error: string = '';
  listResetKey: number = 0;
  selectedCountryCode: string = '';
  selectedLeagueId: number = -1;
  private pref: preferences.Preferences = PreferencesService.getInstance().getPref();
  navigationService: NavigationService = NavigationService.getInstance();

  init(): void {
    this.loadCountries();
  }

  loadCountries(): void {
    this.isLoading = true;
    this.error = '';
    fetchCountries()
      .then(list => {
        this.countries = list;
      })
      .catch((e: BusinessError) => {
        this.error = e.message ?? 'Countries load error';
      })
      .finally(() => {
        this.isLoading = false;
      });
  }

  selectCountry(code: string): void {
    if (!code) {
      return;
    }
    this.selectedCountryCode = code;
    this.isLoading = true;
    this.error = '';

    fetchLeagues(code.toLowerCase())
      .then(list => {
        this.leagues = list;
        this.mode = Mode.League;
        this.listResetKey++;
      })
      .catch((e: BusinessError) => {
        this.error = e.message ?? 'Leagues load error';
      })
      .finally(() => {
        this.isLoading = false;
      });
  }

  selectLeague(leagueId: number): void {
    if (leagueId <= 0) {
      return;
    }
    this.selectedLeagueId = leagueId;
    this.isLoading = true;
    this.error = '';

    fetchTeamsByLeagueSeason(leagueId, 2024)
      .then(list => {
        this.teams = list;
        this.mode = Mode.Team;
        this.listResetKey++;
      })
      .catch((e: BusinessError) => {
        this.error = e.message ?? 'Teams load error';
      })
      .finally(() => {
        this.isLoading = false;
      });
  }

  selectTeam(team: TeamUIModel): void {
    this.setTeam(team);
    console.error('TAG', team.name);
    this.setOnboardingFlag(true);
    const isLoggedIn = this.pref.getSync(Constants.KEY_IS_LOGGED_IN, '') as string;
    this.navigationService.pageInfos.clear();

    if (isLoggedIn) {
      this.navigationService.navigateTo('DashboardPage');
    } else {
      this.navigationService.navigateTo('LoginPage');
    }
  }

  selectLeagueAndPersist(league: League): void {
    this.selectLeague(league.id);
    this.setLeague(league);
  }

  back(): void {
    if (this.mode === Mode.Team) {
      this.mode = Mode.League;
      this.selectedLeagueId = -1;
      this.listResetKey++;
      return;
    }
    if (this.mode === Mode.League) {
      this.mode = Mode.Country;
      this.selectedCountryCode = '';
      this.listResetKey++;
      return;
    }
  }

  setOnboardingFlag(flag: boolean): void {
    this.pref.putSync(Constants.ONBOARDING_FLAG_KEY, flag);
    this.pref.flush();
  }

  setTeam(team: TeamUIModel): void {
    this.pref.putSync(Constants.TEAM_KEY, JSON.stringify(team));
    this.pref.flush();
  }

  getTeam(): TeamUIModel | null {
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

  clearTeam(): void {
    this.pref.deleteSync(Constants.TEAM_KEY);
    this.pref.flush();
  }

  setLeague(league: League): void {
    this.pref.putSync(Constants.LEAGUE_KEY, JSON.stringify(league));
    this.pref.flush();
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

  clearLeague(): void {
    this.pref.deleteSync(Constants.LEAGUE_KEY);
    this.pref.flush();
  }
}
