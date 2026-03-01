import { AppColors, AppTypography } from '../common/Theme';
import { CoachResponseItem } from '../models/coach/CoachApiTypes';
import { TeamUIModel } from '../models/teams/TeamsApiTypes';

@Component
export struct TeamInfoPage {
  @Prop team: TeamUIModel | null;
  @Prop coaches: CoachResponseItem[] | null = null;
  @Prop leagueName: string = '';
  @Prop leagueRank: number = 0;

  build() {
    Column() {
      if (!this.team) {
        Text('No data')
      } else {
        Column() {
          Text('Team Info')
            .fontSize(AppTypography.TITLE_SMALL)
            .fontWeight(FontWeight.Bolder)
            .fontColor(AppColors.TEXT_PRIMARY)
            .margin({ bottom: 18 })

          Column() {
            Row() {
              if (this.team.logo !== '') {
                Image(this.team.logo)
                  .width(22)
                  .height(22)
                  .borderRadius(6)
              }

              Blank()

              Text(this.team.name)
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .maxLines(2)
                .width('60%')

              Blank()

              Text(`${this.team.founded}`)
                .fontSize(14)
            }
            .width('95%')
            .margin({ bottom: 10 })

            Row() {
              Text(this.team.country)
                .fontSize(14)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('40%')

              Blank()

              Text(this.team.venueName)
                .fontSize(14)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width('50%')
            }
            .justifyContent(FlexAlign.Center)
            .width('95%')
            .margin({ bottom: 10 })

            Text(`${this.leagueName} (#${this.leagueRank})`)
              .fontSize(14)
              .width('95%')
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .padding(8)
          .backgroundColor(0x0e2a44)
          .borderRadius(30)
        }
      }
    }
    .backgroundColor(AppColors.BACKGROUND_PRIMARY)
    .padding({ top: 20, left: 12, right: 12 })
    .width('100%')
    .height('100%')
  }
}