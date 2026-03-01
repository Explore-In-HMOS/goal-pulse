import { AppSpacing } from '../../common/Theme';
import { UniversalList } from '../../components/UniversalList';
import { Mode } from '../../models/enums/EnumMode';
import { OnboardingViewModel } from '../../viewmodels/OnboardingViewModel';

@Component
export struct OnboardingPage {
  @State vm: OnboardingViewModel = new OnboardingViewModel();

  aboutToAppear() {
    this.vm.init();
  }

  build() {
    Column() {
      if (this.vm.mode !== Mode.Country) {
        Text($r('app.string.onbaording_back'))
          .padding(AppSpacing.MD)
          .onClick(() => this.vm.back())
          .zIndex(AppSpacing.XXS)
      }

      UniversalList({ vm: this.vm, resetToken: this.vm.listResetKey })

      if (this.vm.error) {
        Text(this.vm.error)
          .padding(AppSpacing.MD)

      }
    }
  }
}
