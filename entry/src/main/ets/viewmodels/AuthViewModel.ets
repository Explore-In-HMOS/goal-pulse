import { PreferencesService } from '../services/PreferencesService';
import { preferences } from '@kit.ArkData';
import { Field } from '../models/InputFieldUiState';
import { Constants } from '../common/utils/Constants';

const emailReg = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

@Observed
export class AuthViewModel {
  private pref: preferences.Preferences = PreferencesService.getInstance().getPref();
  loginEmail: Field = new Field();
  loginPassword: Field = new Field();
  registerFullname: Field = new Field();
  registerEmail: Field = new Field();
  registerPassword: Field = new Field();
  isCorrectPass: boolean = true;
  isRegistered: boolean = true;

  validateLogin(): boolean {
    const email = this.pref.getSync(Constants.KEY_EMAIL, '') as string;
    const pass = this.pref.getSync(Constants.KEY_PASSWORD, '') as string;

    let valid = true;
    this.loginEmail.error = '';
    this.loginPassword.error = '';
    this.isRegistered = true;
    this.isCorrectPass = true;

    if (!emailReg.test(this.loginEmail.value)) {
      this.loginEmail.error = 'Please enter valid e-mail address';
      valid = false;
    }

    if (this.loginPassword.value.length < 6) {
      this.loginPassword.error = 'Please enter valid password';
      valid = false;
    } else if (valid && this.loginEmail.value !== email) {
      this.isRegistered = false;
      valid = false;
    } else if (valid && this.loginEmail.value === email && this.loginPassword.value !== pass) {
      this.isCorrectPass = false;
      valid = false;
    }

    return valid;
  }

  validateRegister(): boolean {
    let valid = true;

    this.registerEmail.error = '';
    this.registerPassword.error = '';
    this.registerFullname.error = '';

    if (!emailReg.test(this.registerEmail.value)) {
      this.registerEmail.error = 'Please enter valid e-mail address';
      valid = false;
    }

    if (this.registerPassword.value.length < 6) {
      this.registerPassword.error = 'Please enter valid password';
      valid = false;
    }

    if (this.registerFullname.value.length < 6) {
      this.registerFullname.error = 'Please enter valid name';
      valid = false;
    }

    return valid;
  }

  clearErrors() {
    this.loginEmail.error = '';
    this.loginPassword.error = '';
    this.registerFullname.error = '';
    this.registerEmail.error = '';
    this.registerPassword.error = '';
  }

  async handleLogin(): Promise<boolean> {
    if (this.validateLogin()) {
      this.pref.putSync(Constants.KEY_IS_LOGGED_IN, true);
      this.pref.flush();
      return true;
    }
    return false;
  }

  async handleRegister(): Promise<boolean> {
    if (this.validateRegister()) {
      this.pref.putSync(Constants.KEY_FULL_NAME, this.registerFullname.value);
      this.pref.putSync(Constants.KEY_EMAIL, this.registerEmail.value);
      this.pref.putSync(Constants.KEY_PASSWORD, this.registerPassword.value);
      this.pref.putSync(Constants.KEY_IS_LOGGED_IN, true);
      this.pref.flush();
      return true;
    }
    return false;
  }

  async logout(): Promise<boolean> {
    try {
      this.pref.putSync(Constants.KEY_IS_LOGGED_IN, false);
      this.pref.flush();
      return true;
    } catch (e) {
      console.error(`Logout Error ${e}`)
      return false;
    }
  }
}