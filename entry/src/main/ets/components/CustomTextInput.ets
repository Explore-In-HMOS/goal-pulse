import { AppColors, AppTypography } from '../common/Theme';
import { Field } from '../models/InputFieldUiState';

@Component
export struct CustomTextInput {
  @Prop placeholder: string;
  @State inputType: InputType = InputType.Normal;
  @ObjectLink field: Field;

  aboutToAppear(): void {
    if (this.placeholder === 'Email') {
      this.inputType = InputType.Email;
    } else if (this.placeholder === 'Password') {
      this.inputType = InputType.Password;
    } else {
      this.inputType = InputType.Normal;
    }
  }

  build() {
    Column() {
      TextInput({ placeholder: this.placeholder })
        .type(this.inputType)
        .placeholderColor($r('sys.color.navigation_drag_bar_item_default'))
        .placeholderFont({ size: AppTypography.BODY_SMALL })
        .fontSize(AppTypography.BODY_SMALL)
        .fontColor(Color.White)
        .backgroundColor('rgba(255, 255, 255, 0.08)')
        .height(34)
        .borderRadius(16)
        .margin({ right: 6, left: 6 })
        .border({ width: this.field.error ? 1 : 0, color: AppColors.ACCENT_RED })
        .onChange((value: string) => {
          this.field.value = value;
          if (this.field.error) {
            this.field.error = '';
          }
        })

      if (this.field.error) {
        Text(this.field.error)
          .fontColor(AppColors.ACCENT_RED)
          .fontSize(AppTypography.BODY_X_SMALL)
          .width('90%')
          .textAlign(TextAlign.Start)
      }
    }
  }
}