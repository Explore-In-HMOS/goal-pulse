import { AppColors, AppSpacing, AppTypography } from '../../common/Theme';
import { NavigationService } from '../../services/NavigationService';
import { ArcButton, ArcButtonOptions, ArcButtonPosition, ArcButtonStyleMode, ColorMetrics, Font } from '@kit.ArkUI';
import { AuthViewModel } from '../../viewmodels/AuthViewModel';
import { CustomTextInput } from '../../components/CustomTextInput';

@Component
export struct LoginPage {
  navigationService: NavigationService = NavigationService.getInstance();
  @State currentIndex: number = 0;
  @State selectedIndex: number = 0;
  private controller: TabsController = new TabsController();
  @State vm: AuthViewModel = new AuthViewModel();

  build() {
    Column() {
      Text('Welcome!')
        .fontSize(AppTypography.TITLE_MEDIUM)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .margin({ top: AppSpacing.MD, bottom: AppSpacing.XS })

      Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
        TabContent() {
          Column() {
            Scroll() {
              Column() {
                CustomTextInput({ placeholder: 'Email', field: this.vm.loginEmail })
                CustomTextInput({ placeholder: 'Password', field: this.vm.loginPassword }).margin({ top: 6 })

                ArcButton({
                  options: new ArcButtonOptions({
                    label: 'Login',
                    styleMode: ArcButtonStyleMode.CUSTOM,
                    position: ArcButtonPosition.BOTTOM_EDGE,
                    backgroundColor: ColorMetrics.resourceColor(AppColors.PRIMARY),
                    onClick: async () => {
                      await this.vm.handleLogin().then((value)=> {
                        if (value) {
                          this.navigationService.navigateTo('DashboardPage');
                        } else {
                          if (!this.vm.isRegistered) {
                            this.getUIContext().getPromptAction().showToast({
                              message: 'Please first register'
                            })
                          } else {
                            if (!this.vm.isCorrectPass) {
                              this.getUIContext().getPromptAction().showToast({
                                message: 'Incorrect password'
                              })
                            }
                          }
                        }
                      });
                    }
                  })
                }).margin({ top: 20 })
              }
            }.height('100%')
            .scrollBar(BarState.Off)
          }.width('100%')
          .height('100%')
          .padding(2)
          .justifyContent(FlexAlign.SpaceBetween)
        }.tabBar(this.tabBuilder(0, 'Login'))

        TabContent() {
          Column() {
            Scroll() {
              Column() {
                CustomTextInput({ placeholder: 'Full Name', field: this.vm.registerFullname })
                CustomTextInput({ placeholder: 'Email', field: this.vm.registerEmail }).margin({ top: 6 })
                CustomTextInput({ placeholder: 'Password', field: this.vm.registerPassword }).margin({ top: 6 })

                ArcButton({
                  options: new ArcButtonOptions({
                    label: 'Register',
                    styleMode: ArcButtonStyleMode.CUSTOM,
                    position: ArcButtonPosition.BOTTOM_EDGE,
                    backgroundColor: ColorMetrics.resourceColor(AppColors.PRIMARY),
                    onClick: async () => {
                      await this.vm.handleRegister().then((value)=> {
                        if (value) {
                          this.navigationService.navigateTo('DashboardPage');
                        }
                      });
                    }
                  })
                }).margin({ top: 6 })
              }
            }.height('100%')
            .scrollBar(BarState.Off)
          }.width('100%')
          .height('100%')
          .padding(2)
          .justifyContent(FlexAlign.SpaceBetween)
        }.tabBar(this.tabBuilder(1, 'Register'))
      }
      .vertical(false)
      .barMode(BarMode.Fixed)
      .barWidth(360)
      .barHeight(42)
      .animationDuration(400)
      .onChange((index: number) => {
        this.currentIndex = index;
        this.selectedIndex = index;
        this.vm.clearErrors();
      })
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        if (index === targetIndex) {
          return;
        }
        this.selectedIndex = targetIndex;
      })
      .width('96%')
      .height('85%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BACKGROUND_PRIMARY)
  }

  @Builder
  tabBuilder(index: number, name: string) {
    Column() {
      Text(name)
        .fontColor(this.selectedIndex === index ? AppColors.TEXT_PRIMARY : AppColors.TEXT_TERTIARY)
        .fontSize(AppTypography.TITLE_SMALL)
        .fontWeight(this.selectedIndex === index ? 500 : 400)
        .margin(6)
      Divider()
        .strokeWidth(2)
        .color(AppColors.PRIMARY)
        .opacity(this.selectedIndex === index ? 1 : 0)
    }.width('100%')
  }
}