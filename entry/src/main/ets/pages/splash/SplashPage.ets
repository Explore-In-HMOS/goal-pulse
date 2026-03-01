import { NavigationService } from '../../services/NavigationService';
import lottie, { AnimationItem } from '@ohos/lottie';
import { AppColors, AppDimensions, AppSpacing, AppTypography } from '../../common/Theme';
import { SplashViewModel } from '../../viewmodels/SplashViewModel';
import { Constants } from '../../common/utils/Constants';
import { preferences } from '@kit.ArkData';
import { PreferencesService } from '../../services/PreferencesService';

@Component
export struct SplashPage {
  navigationService: NavigationService = NavigationService.getInstance();
  private animateItem: AnimationItem | null = null;
  private animateName: string = 'animation';
  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings);
  vm: SplashViewModel = new SplashViewModel();
  private pref: preferences.Preferences = PreferencesService.getInstance().getPref();

  async aboutToAppear() {
    setTimeout(async () => {
      const isLoggedIn = this.pref.getSync(Constants.KEY_IS_LOGGED_IN, false) as boolean;
      this.navigationService.pageInfos.clear();
      const onboardingFlag = this.vm.getOnboardingFlag();

      if (onboardingFlag) {
        if (isLoggedIn) {
          this.navigationService.navigateTo('DashboardPage');
        } else {
          this.navigationService.navigateTo('LoginPage');
        }
      } else {
        this.navigationService.navigateTo('OnboardingPage');
      }

    }, 2000);
  }

  aboutToDisappear(): void {
    this.destroy()
  }

  destroy() {
    this.animateItem?.removeEventListener('DOMLoaded');
    lottie.destroy(this.animateName);
    this.animateItem = null;
  }

  loadAnimation() {
    this.animateItem = lottie.loadAnimation({
      container: this.canvasRenderingContext,
      renderer: 'canvas',
      loop: true,
      autoplay: true,
      name: this.animateName,
      contentMode: 'Contain',
      path: 'animation/football.json'
    });
  }

  build() {
    Column() {
      Canvas(this.canvasRenderingContext)
        .width(AppDimensions.ICON_XXL)
        .height(AppDimensions.ICON_XXL)
        .onReady(() => {
          if (this.animateItem !== null) {
            this.animateItem?.resize();
          } else {
            this.canvasRenderingContext.imageSmoothingEnabled = true;
            this.loadAnimation();
          }
        })
        .onDisAppear(()=>{
          this.destroy()
        })
      Text($r('app.string.app_title'))
        .fontWeight(FontWeight.Bold)
        .fontSize(AppTypography.HEADLINE_SMALL)
    }
    .width(AppDimensions.FULL_SIZE)
    .height(AppDimensions.FULL_SIZE)
    .backgroundColor(AppColors.BACKGROUND_PRIMARY)
  }
}