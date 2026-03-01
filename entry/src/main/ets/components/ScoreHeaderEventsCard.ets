import { AppColors, AppTypography } from '../common/Theme';
import { MiniEventVM } from '../models/fixtures/FixtureApiTypes';

@Component
export struct ScoreHeaderEventsCard {
  @Prop homeTitle: string = '';
  @Prop awayTitle: string = '';
  @Prop homeLines: MiniEventVM[] = [];
  @Prop awayLines: MiniEventVM[] = [];

  @Builder
  private eventLine(it: MiniEventVM) {
    Column() {
      Row({space: 3}) {
        Text(it.icon)
          .fontSize(12)

        Text(it.minute)
          .fontSize(12)
          .fontColor(AppColors.TEXT_PRIMARY)
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      Text(it.who)
        .fontSize(13)
        .fontColor(AppColors.TEXT_PRIMARY)
        .textAlign(TextAlign.Start)
    }
    .margin({ bottom: 16 })
  }

  build() {
    Column() {
      Text('Goals & Cards')
        .fontSize(AppTypography.TITLE_SMALL)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppColors.TEXT_SECONDARY)
        .margin({ bottom: 8 })

      Row() {
        Column() {
          Text('HOME')
            .fontSize(AppTypography.BODY_SMALL)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppColors.TEXT_SECONDARY)
            .margin({ bottom: 8 })

          ForEach(this.homeLines, (it: MiniEventVM) => {
            this.eventLine(it);
          }, (it: MiniEventVM) => it.key)
        }
        .layoutWeight(1)
        .margin({ right: 10 })

        Column() {
          Text('AWAY')
            .fontSize(AppTypography.BODY_SMALL)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppColors.TEXT_SECONDARY)
            .margin({ bottom: 8 })

          ForEach(this.awayLines, (it: MiniEventVM) => {
            this.eventLine(it);
          }, (it: MiniEventVM) => it.key)
        }
        .layoutWeight(1)
        .margin({ left: 10 })
      }
      .alignItems(VerticalAlign.Top)
      .width('100%')
      .padding({
        left: 14,
        right: 14,
        top: 12
      })
      .backgroundColor(0x0e2a44)
      .borderRadius(20)
      .margin({ bottom: 18 })
    }
  }
}
