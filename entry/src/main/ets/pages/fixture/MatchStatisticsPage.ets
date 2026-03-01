import { MatchMetaHeader } from '../../components/MatchMetaHeader';
import { ScoreHeaderCard } from '../../components/ScoreHeaderCard';
import { ScoreHeaderEventsCard } from '../../components/ScoreHeaderEventsCard';
import { AllStatsSection } from '../../components/AllStatsSection';
import { MatchStatisticsViewModel } from '../../viewmodels/MatchStatisticsViewModel';
import { AppColors, AppDimensions, AppSpacing, AppTypography } from '../../common/Theme';
import { uiObserver } from '@kit.ArkUI';

@Component
export struct MatchStatisticsPage {
  navDesInfo: uiObserver.NavDestinationInfo | undefined;
  @State private vm: MatchStatisticsViewModel = new MatchStatisticsViewModel();

  aboutToAppear(): void {
    this.navDesInfo = this.queryNavDestinationInfo();
    const raw = this.navDesInfo?.param;

    const id = raw ? Number(raw) : NaN;
    const fixtureId = Number.isFinite(id) ? id : -1;

    this.vm.init(fixtureId);
  }

  build() {
    Column() {
      if (this.vm.isLoading) {
        Column(){
          LoadingProgress()
            .width(AppDimensions.LOADING_SIZE)
            .height(AppDimensions.LOADING_SIZE)
            .zIndex(AppSpacing.XS)
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
      } else if (this.vm.error.length > 0) {
        Column() {
          Text(this.vm.error)
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('100%')
      } else {
        Scroll() {
          Column() {
            Text('Match Statistics')
              .textAlign(TextAlign.Center)
              .width('100%')
              .fontSize(AppTypography.TITLE_SMALL)
              .fontWeight(FontWeight.Bolder)
              .margin({ bottom: 12 })

            ScoreHeaderCard({
              homeName: this.vm.homeNameCode,
              awayName: this.vm.awayNameCode,
              homeLogo: this.vm.homeLogo,
              awayLogo: this.vm.awayLogo,
              scoreText: this.vm.scoreText,
              statusText: this.vm.statusText
            })

            MatchMetaHeader({
              leagueName: this.vm.leagueName,
              venueName: this.vm.venueName
            })

            if (this.vm.homeLines.length > 0 || this.vm.awayLines.length > 0) {
              ScoreHeaderEventsCard({
                homeTitle: this.vm.homeNameCode,
                awayTitle: this.vm.awayNameCode,
                homeLines: this.vm.homeLines,
                awayLines: this.vm.awayLines
              })
            }

            AllStatsSection({ rows: this.vm.statRows })
          }
          .width('100%')
          .padding({
            left: 18,
            right: 18,
            top: 18,
            bottom: 18
          })
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BACKGROUND_PRIMARY)
  }
}
