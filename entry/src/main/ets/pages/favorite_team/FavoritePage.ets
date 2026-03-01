import { AppColors, AppDimensions, AppSpacing } from '../../common/Theme';
import { FavoriteViewModel } from '../../viewmodels/FavoriteViewModel';
import { TeamInfoPage } from '../../components/TeamInfoPage';
import { StandingsPage } from '../../components/StandingsPage';
import { TeamNewsPage } from '../../components/TeamNewsPage';
import { PlayersPage } from '../../components/PlayersPage';

@Component
export struct FavoritePage {
  @State vm: FavoriteViewModel = new FavoriteViewModel();

  async aboutToAppear() {
    const ok = this.vm.init();
    if (!ok) {
      return;
    }
    await this.vm.loadAll();
  }

  build() {
    Stack() {
      if (this.vm.isLoading) {
        LoadingProgress()
          .width(AppDimensions.LOADING_SIZE)
          .height(AppDimensions.LOADING_SIZE)
          .zIndex(AppSpacing.XS)
      } else if (this.vm.errorMsg) {
        Text(this.vm.errorMsg)
      } else {
        Swiper() {
          TeamInfoPage({
            team: this.vm.team,
            coaches: this.vm.coaches,
            leagueName: this.vm.league?.name,
            leagueRank: this.vm.standingStatistic?.rank ?? 0
          })

          StandingsPage({ standings: this.vm.standings, leagueName: this.vm.league?.name })

          TeamNewsPage({
            news: this.vm.articles,
            hasMore: this.vm.hasMore,
            isLoading: this.vm.isLoading,
            onItemClicked: () => this.vm.loadNews()
          })

          PlayersPage({ players: this.vm.players })
        }
        .index(this.vm.pageIndex)
        .onChange((i: number) => this.vm.setPageIndex(i))
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BACKGROUND_PRIMARY)
  }
}
