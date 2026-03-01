import { formatDateLine, formatTimeLine, getTeamCodeFromName } from '../common/utils/HelperFunctions';
import { ArcList, ArcListItem, ComponentContent, ArcListAttribute, ArcListItemAttribute, LengthMetrics } from '@kit.ArkUI';
import { FixtureListItem } from '../models/fixtures/FixturesListItem';
import { AppColors, AppDimensions, AppTypography } from '../common/Theme';

@Builder
function nextHeader() {
  Text('Next Matches')
    .fontSize(AppTypography.TITLE_SMALL)
    .fontWeight(FontWeight.Bolder)
    .fontColor(AppColors.TEXT_PRIMARY)
}

@Component
export struct NextWeekPage {
  @Prop fixtures: FixtureListItem[] = [];
  @Prop isLoading: boolean = false;
  @Prop error: string = '';
  onSelectFixture: (fixtureId: number) => void = () => {
  };
  comCont = new ComponentContent(this.getUIContext(), wrapBuilder(nextHeader));

  build() {
    Column() {
      ArcList({ header: this.comCont }) {
        ForEach(this.fixtures, (fx: FixtureListItem) => {
          ArcListItem() {
            NextWeekItem({ fx: fx })
          }
          .width('90%')
          .margin({ bottom: 6 })
        }, (fx: FixtureListItem) => `${fx.fixture.id}`)
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BACKGROUND_PRIMARY)
  }
}

@Component
struct NextWeekItem {
  @Prop fx: FixtureListItem;

  @State private homeCode: string = '';
  @State private awayCode: string = '';
  @State private dateLine: string = '';
  @State private timeLine: string = '';

  aboutToAppear(): void {
    this.homeCode = getTeamCodeFromName(this.fx.teams.home.name);
    this.awayCode = getTeamCodeFromName(this.fx.teams.away.name);
    this.dateLine = formatDateLine(this.fx.fixture.date);
    this.timeLine = formatTimeLine(this.fx.fixture.date);
  }

  build() {
    Row() {
      Row() {
        Image(this.fx.teams.home.logo)
          .width(AppDimensions.ITEM_ICON_SIZE)
          .height(AppDimensions.ITEM_ICON_SIZE)
        Text(this.homeCode)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppColors.TEXT_PRIMARY)
          .margin({ left: 8 })
      }.alignItems(VerticalAlign.Center)

      Blank()

      Column() {
        Text(this.dateLine)
          .fontSize(11)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY)
          .textAlign(TextAlign.Center)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.timeLine)
          .fontSize(11)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppColors.TEXT_SECONDARY)
          .textAlign(TextAlign.Center)
          .margin({ top: 2 })
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width('30%')

      Blank()

      Row() {
        Text(this.awayCode)
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor(AppColors.TEXT_PRIMARY)
          .margin({ right: 8 })
        Image(this.fx.teams.away.logo)
          .width(AppDimensions.ITEM_ICON_SIZE)
          .height(AppDimensions.ITEM_ICON_SIZE)
      }.alignItems(VerticalAlign.Center)
    }
    .justifyContent(FlexAlign.Center)
    .padding({
      left: 12,
      right: 12,
      top: 4,
      bottom: 4
    })
    .backgroundColor(0x0e2a44)
    .borderRadius(16)
    .width('100%')
  }
}