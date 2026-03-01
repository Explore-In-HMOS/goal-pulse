import { NavigationService } from '../services/NavigationService';
import { SplashPage } from '../pages/splash/SplashPage';
import GlobalContext from '../common/utils/GlobalContext';
import { common } from '@kit.AbilityKit';
import { LoginPage } from '../pages/login/LoginPage';
import { OnboardingPage } from './onboarding/OnboardingPage';
import { DashboardPage } from './dashboard/DashboardPage';
import { FavoritePage } from './favorite_team/FavoritePage';
import { LivePage } from './live/LivePage';
import { FixturePage } from './fixture/FixturePage';
import { ProfilePage } from './profile/ProfilePage';
import { MatchStatisticsPage } from './fixture/MatchStatisticsPage';
import { NotificationViewModel } from '../viewmodels/NotificationViewModel';

@Entry
@Component
struct Index {
  navigationService: NavigationService = NavigationService.getInstance();
  @State vm: NotificationViewModel = new NotificationViewModel();

  @Builder
  routeMap(name: string) {
    NavDestination() {
      if (name === 'SplashPage') {
        SplashPage()
      } else if (name === 'OnboardingPage') {
        OnboardingPage()
      } else if (name === 'LoginPage') {
        LoginPage()
      } else if (name === 'DashboardPage') {
        DashboardPage()
      } else if (name === 'FavoritePage') {
        FavoritePage()
      } else if (name === 'LivePage') {
        LivePage()
      } else if (name === 'FixturePage') {
        FixturePage()
      } else if (name === 'ProfilePage') {
        ProfilePage()
      } else if (name === 'MatchStatisticsPage') {
        MatchStatisticsPage()
      }
    }
    .onBackPressed(() => {
      if (name === 'DashboardPage' || name === 'LoginPage' || name === 'SplashPage') {
        this.terminateApp();
        return true;
      }
      return false;
    })
    .hideTitleBar(true)
  }

  build() {
    Navigation(this.navigationService.pageInfos)
      .onAppear(() => {
        this.navigationService.navigateTo('SplashPage');
        this.vm.getData();
      })
      .mode(NavigationMode.Stack)
      .navDestination(this.routeMap)
      .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.BOTTOM])
      .hideTitleBar(true)
      .width('100%')
      .height('100%')
  }

  private terminateApp() {
    const context = GlobalContext.getInstance().getCntx() as common.UIAbilityContext;
    if (context) {
      context.terminateSelf();
    }
  }
}
