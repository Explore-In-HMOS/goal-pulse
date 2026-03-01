import { AppColors } from '../common/Theme';

@Component
export struct MatchMetaHeader {
  @Prop leagueName: string = '';
  @Prop venueName: string = '';

  build() {
    Column({space: 6}) {
      if (this.leagueName.length > 0) {
        Text(this.leagueName)
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppColors.TEXT_SECONDARY)
          .textAlign(TextAlign.Center)
          .width('100%')
      }

      if (this.venueName.length > 0) {
        Text(this.venueName)
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppColors.TEXT_SECONDARY)
          .textAlign(TextAlign.Center)
          .width('100%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
    }
    .margin({ bottom: 12 })
  }
}