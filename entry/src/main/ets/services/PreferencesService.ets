import { preferences } from '@kit.ArkData';
import type { Context } from '@kit.AbilityKit';
import { Constants } from '../common/utils/Constants';

export class PreferencesService {
  private static instance: PreferencesService;
  private pref: preferences.Preferences | null = null;

  static getInstance(): PreferencesService {
    if (!PreferencesService.instance) {
      PreferencesService.instance = new PreferencesService();
    }
    return PreferencesService.instance;
  }

  init(context: Context): void {
    if (this.pref) {
      return;
    }
    this.pref = preferences.getPreferencesSync(context, { name: Constants.PREF_NAME });
  }

  getPref(): preferences.Preferences {
    if (!this.pref) {
      throw new Error('PreferencesService not initialized. Call init(context) in EntryAbility.onCreate().');
    }
    return this.pref;
  }
}
