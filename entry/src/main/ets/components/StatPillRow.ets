import { AppColors } from '../common/Theme';

@Component
export struct StatPillRow {
  @Prop leftText: string = '-';
  @Prop rightText: string = '-';
  @Prop centerLabel: string = '';

  build() {
    Row() {
      Text(this.leftText)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppColors.TEXT_PRIMARY)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Text(this.centerLabel)
        .fontSize(12)
        .fontWeight(FontWeight.Medium)
        .fontColor(AppColors.TEXT_SECONDARY)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Text(this.rightText)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppColors.TEXT_PRIMARY)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(46)
    .padding({ left: 14, right: 14 })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(0x0e2a44)
    .borderRadius(16)
    .margin({ bottom: 12 })
  }
}
