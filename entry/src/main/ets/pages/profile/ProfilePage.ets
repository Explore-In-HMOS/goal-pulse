import { AppColors, AppDimensions, AppSpacing, AppTypography } from '../../common/Theme'
import { NavigationService } from '../../services/NavigationService';
import { AuthViewModel } from '../../viewmodels/AuthViewModel';
import { preferences } from '@kit.ArkData';
import { PreferencesService } from '../../services/PreferencesService';
import { Constants } from '../../common/utils/Constants';

@Component
export struct ProfilePage {
  @State vm: AuthViewModel = new AuthViewModel();
  @State userName: string = '';
  navigationService: NavigationService = NavigationService.getInstance();
  private pref: preferences.Preferences = PreferencesService.getInstance().getPref();

  aboutToAppear(): void {
    const name = this.pref.getSync(Constants.KEY_FULL_NAME, '') as string;
    this.userName = name
  }

  build() {
    Column() {
      Text(`Hi ${this.userName}!`)
        .fontSize(AppTypography.TITLE_MEDIUM)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .margin({ bottom: AppSpacing.XXS })

      Row() {
        SymbolGlyph($r('sys.symbol.figure_football'))
          .fontSize(20)
          .fontColor([Color.White])
          .margin(4)
        Text('Change Your Team')
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 8 })
      }
      .width('80%')
      .padding(4)
      .backgroundColor(0x0e2a44)
      .borderRadius(16)
      .margin({ top: 20 })
      .onClick(() => {
        this.navigationService.navigateTo('OnboardingPage')
      })

      Row() {
        SymbolGlyph($r('sys.symbol.rectangle_and_arrowshape_turn_up_right'))
          .fontSize(20)
          .fontColor([Color.White])
          .margin(4)
        Text('Logout')
          .fontSize(12)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 8 })
      }
      .width('80%')
      .padding(4)
      .backgroundColor(AppColors.ACCENT_RED_CONTAINER)
      .borderRadius(16)
      .margin({ top: 10 })
      .onClick(async () => {
        await this.vm.logout().then((value)=> {
          if (value) {
            this.navigationService.clearStackAndNavigate('LoginPage');
          } else {
            console.error('Logout Error')
          }
        })
      })

    }.width(AppDimensions.FULL_SIZE)
    .height(AppDimensions.FULL_SIZE)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(AppColors.BACKGROUND_PRIMARY)
  }
}