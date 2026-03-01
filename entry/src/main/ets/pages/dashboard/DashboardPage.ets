import { AppColors, AppDimensions, AppRadius, AppSpacing, AppTypography } from '../../common/Theme';
import { DashboardItem } from '../../components/DashboardItem';
import { NavigationService } from '../../services/NavigationService';

@Component
export struct DashboardPage {
  navigationService: NavigationService = NavigationService.getInstance();

  build() {
    Column() {
      Text('Dashboard')
        .fontSize(AppTypography.TITLE_MEDIUM)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .margin({ top: AppSpacing.MD, bottom: AppSpacing.XS })

      Grid() {
        GridItem() {
          DashboardItem({ title: 'My Team', icon: $r('sys.symbol.star') })
        }.onClick(() => {
          this.navigationService.navigateTo('FavoritePage');
        })

        GridItem() {
          DashboardItem({ title: 'The Live Match', icon: $r('sys.symbol.figure_running') })
        }.onClick(() => {
          this.navigationService.navigateTo('LivePage');
        })

        GridItem() {
          DashboardItem({ title: 'League Fixture', icon: $r('sys.symbol.grid') })
        }.onClick(() => {
          this.navigationService.navigateTo('FixturePage');
        })

        GridItem() {
          DashboardItem({ title: 'Profile', icon: $r('sys.symbol.person') })
        }.onClick(() => {
          this.navigationService.navigateTo('ProfilePage');
        })

      }
      .rowsTemplate('1fr 1fr')
      .columnsTemplate('1fr 1fr')
      .width('76%')
      .height('66%')

    }
    .backgroundColor(AppColors.BACKGROUND_PRIMARY)
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
  }
}