import { AppColors, AppDimensions, AppRadius, AppSpacing, AppTypography } from '../common/Theme';

@Component
export struct DashboardItem {
  @Prop icon: Resource;
  @Prop title: string;
  build() {
    Column() {
      SymbolGlyph(this.icon)
        .fontSize(20)
        .fontColor([Color.White])
        .margin(4)
      Text(this.title)
        .fontSize(AppTypography.BODY_SMALL)
    }.padding(AppSpacing.MD)
    .backgroundColor(AppColors.SURFACE_INPUT)
    .width('94%')
    .height('94%')
    .borderRadius(AppRadius.LG)
    .borderWidth(AppDimensions.BORDER_HAIRLINE)
    .borderColor(AppColors.BORDER_DEFAULT)
    .justifyContent(FlexAlign.Center)
  }
}