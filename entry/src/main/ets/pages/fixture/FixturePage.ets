import { AppColors } from '../../common/Theme'
import { LastWeekPage } from '../../components/LastWeekPage'
import { MatchesInfoPage } from '../../components/MatchesInfoPage'
import { NextWeekPage } from '../../components/NextWeekPage'
import { StandingsPage } from '../../components/StandingsPage'
import { NavigationService } from '../../services/NavigationService'
import { FixturePageViewModel } from '../../viewmodels/FixtureViewModel'

@Component
export struct FixturePage {
  @State private currentIndex: number = 0;
  @State private vm: FixturePageViewModel = new FixturePageViewModel();
  navigationService: NavigationService = NavigationService.getInstance();

  aboutToAppear() {
    this.vm.init(39, 2024);
  }

  private openMatch(fixtureId: number): void {
    this.navigationService.navigateToWithArgs(
      'MatchStatisticsPage',
      fixtureId.toString()
    );
  }

  build() {
    Column() {
      Swiper() {

        MatchesInfoPage({
          onItemClick: (index: number) => {
            this.currentIndex = index
          }
        })

        LastWeekPage({
          fixtures: this.vm.lastFixtures,
          isLoading: this.vm.isLoading,
          error: this.vm.error,
          onSelectFixture: (id: number) => this.openMatch(id)
        })

        StandingsPage({ standings: this.vm.standings, leagueName: this.vm.league?.name })

        NextWeekPage({
          fixtures: this.vm.nextFixtures,
          isLoading: this.vm.isLoading,
          error: this.vm.error
        })
      }
      .index(this.currentIndex)
      .onChange((i: number) => {
        this.currentIndex = i;
      })
      .loop(false)
      .indicator(true)
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BACKGROUND_PRIMARY)
  }
}
