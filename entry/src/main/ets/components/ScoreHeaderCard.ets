import { AppColors, AppDimensions, AppTypography } from '../common/Theme';

@Component
export struct ScoreHeaderCard {
  @Prop homeName: string = '';
  @Prop awayName: string = '';
  @Prop homeLogo: string = '';
  @Prop awayLogo: string = '';
  @Prop scoreText: string = '';
  @Prop statusText: string = '';

  build() {
    Row() {
      Row() {
        Image(this.homeLogo)
          .width(AppDimensions.ITEM_ICON_SIZE)
          .height(AppDimensions.ITEM_ICON_SIZE)
        Text(this.homeName)
          .fontSize(AppTypography.TITLE_SMALL)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ left: 4 })
      }
      .alignItems(VerticalAlign.Center)

      Column() {
        Text(this.scoreText)
          .fontSize(AppTypography.TITLE_SMALL)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY)
          .textAlign(TextAlign.Center)

        Text(this.statusText)
          .fontSize(AppTypography.BODY_SMALL)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppColors.TEXT_SECONDARY)
          .textAlign(TextAlign.Center)
          .margin({ top: 2 })
      }
      .alignItems(HorizontalAlign.Center)
      .margin({ left: 8, right: 8 })

      Row() {
        Text(this.awayName)
          .fontSize(AppTypography.TITLE_SMALL)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ right: 4 })
        Image(this.awayLogo)
          .width(AppDimensions.ITEM_ICON_SIZE)
          .height(AppDimensions.ITEM_ICON_SIZE)
      }
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(0x0e2a44)
    .borderRadius(16)
    .margin({ bottom: 8 })
  }
}