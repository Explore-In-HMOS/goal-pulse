import { AppColors, AppTypography } from '../common/Theme';
import { StatRowVM } from '../models/fixtures/FixtureApiTypes';
import { StatPillRow } from './StatPillRow';

@Component
export struct AllStatsSection {
  @Prop rows: StatRowVM[] = [];

  build() {
    Column() {
      Text('Match Stats')
        .fontSize(AppTypography.TITLE_SMALL)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppColors.TEXT_SECONDARY)
        .margin({ bottom: 8 })

      Column() {
        ForEach(this.rows, (r: StatRowVM) => {
          StatPillRow({ leftText: r.left, centerLabel: r.label, rightText: r.right })
        }, (r: StatRowVM) => r.key)

        if (this.rows.length === 0) {
          StatPillRow({ leftText: '-', centerLabel: 'No statistics', rightText: '-' })
        }
      }
      .width('100%')
    }
    .margin({bottom: 18})
  }
}
