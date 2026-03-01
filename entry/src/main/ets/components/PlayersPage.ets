import { AppColors, AppTypography } from '../common/Theme';
import { SquadPlayer } from '../models/squads/SquadsApiTypes';
import { ArcList, ArcListItem, ComponentContent, ArcListAttribute, ArcListItemAttribute, LengthMetrics } from '@kit.ArkUI';
import { playerPosition } from '../models/enums/EnumPlayers';

@Builder
function playersHeader() {
  Text('Players')
    .fontSize(AppTypography.TITLE_SMALL)
    .fontWeight(FontWeight.Bolder)
    .fontColor(AppColors.TEXT_PRIMARY)
}

@Component
export struct PlayersPage {
  @Prop players: SquadPlayer[];
  comCont = new ComponentContent(this.getUIContext(), wrapBuilder(playersHeader));

  build() {
    Column() {
      ArcList({ initialIndex: 0, header: this.comCont }) {
        ForEach(this.players, (p: SquadPlayer) => {
          ArcListItem() {
            Row({ space: 8 }) {
              Text(p.name)
                .layoutWeight(1)
                .fontSize(12)
                .fontWeight(FontWeight.Medium)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Text(playerPosition(p.position))
                .width(40)
                .textAlign(TextAlign.End)
                .fontSize(11)
                .opacity(0.85)

              Text(p.number !== null ? `#${p.number}` : '-')
                .width(40)
                .textAlign(TextAlign.End)
                .fontSize(11)
                .opacity(0.85)
            }
            .padding({
              left: 18,
              right: 18,
              top: 10,
              bottom: 10
            })
            .backgroundColor(0x0e2a44)
            .borderRadius(16)
          }
          .width('90%')
          .margin({ bottom: 6 })
        }, (p: SquadPlayer) => `${p.id}`)
      }
      .scrollBar(BarState.Off)
      .width('100%')
      .height('100%')
    }
    .backgroundColor(AppColors.BACKGROUND_PRIMARY)
    .width('100%')
    .height('100%')
  }
}