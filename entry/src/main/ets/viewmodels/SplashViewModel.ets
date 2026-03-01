import { Constants } from '../common/utils/Constants';
import { PreferencesService } from '../services/PreferencesService';

@Observed
export class SplashViewModel {
  private pref = PreferencesService.getInstance();

  getOnboardingFlag(def: boolean = false): boolean {
    const v = this.pref.getPref().getSync(Constants.ONBOARDING_FLAG_KEY, def) as boolean;
    return v ? v : def;
  }
}
