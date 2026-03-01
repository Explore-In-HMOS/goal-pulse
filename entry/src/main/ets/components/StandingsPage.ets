import { AppColors, AppTypography } from '../common/Theme';
import { Standing, StandingsHeaderArgs } from '../models/standing/StandingApiTypes';
import { ArcList, ArcListItem, ComponentContent, ArcListAttribute, ArcListItemAttribute, LengthMetrics } from '@kit.ArkUI';

@Builder
function standingsHeader(args: StandingsHeaderArgs) {
  Text(args.leagueName || '-')
    .fontSize(AppTypography.TITLE_SMALL)
    .fontWeight(FontWeight.Bolder)
    .fontColor(AppColors.TEXT_PRIMARY)
}

@Component
export struct StandingsPage {
  @Prop standings: Standing[];
  @Prop @Watch('onLeagueNameChanged') leagueName: string = '';
  private headerContent?: ComponentContent<StandingsHeaderArgs>;

  aboutToAppear() {
    this.headerContent = new ComponentContent<StandingsHeaderArgs>(
      this.getUIContext(),
      wrapBuilder<[StandingsHeaderArgs]>(standingsHeader),
      { leagueName: this.leagueName }
    );
  }

  aboutToDisappear() {
    this.headerContent?.dispose();
    this.headerContent = undefined;
  }

  onLeagueNameChanged() {
    this.headerContent?.update({ leagueName: this.leagueName });
  }

  build() {
    Column() {
      ArcList({ initialIndex: 0, header: this.headerContent }) {
        ForEach(this.standings, (s: Standing) => {
          ArcListItem() {
            Column() {
              Row({ space: 8 }) {
                Text('#').fontSize(8).opacity(0.8)
                Text('Team').layoutWeight(1).fontSize(8).opacity(0.8)
                Text('MP').textAlign(TextAlign.End).fontSize(8).opacity(0.8)
                Text('PTS').textAlign(TextAlign.End).fontSize(8).opacity(0.8)
              }
              .padding({ left: 10, right: 10, bottom: 4 })

              Row({ space: 8 }) {
                Text(`${s.rank}`)
                  .fontSize(12)
                  .opacity(0.9)

                Text(s.team.name)
                  .layoutWeight(1)
                  .fontSize(12)
                  .fontWeight(FontWeight.Medium)

                Text(`${s.all.played}`)
                  .textAlign(TextAlign.End)
                  .fontSize(12)

                Text(`${s.points}`)
                  .textAlign(TextAlign.End)
                  .fontSize(12)
                  .fontWeight(FontWeight.Bold)
              }
              .padding(10)
              .backgroundColor(0x0e2a44)
              .borderRadius(16)
            }
          }
          .width('90%')
          .margin({ bottom: 10 })
        }, (s: Standing) => `${s.team.id}`)
      }
      .width('100%')
      .scrollBar(BarState.Off)
    }
    .backgroundColor(AppColors.BACKGROUND_PRIMARY)
    .width('100%')
    .height('100%')
  }
}