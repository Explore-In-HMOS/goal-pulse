import { getTeamCodeFromName, safeNumToText } from '../common/utils/HelperFunctions';
import { FixtureListItem } from '../models/fixtures/FixturesListItem';
import {
  ArcList,
  ArcListItem,
  ComponentContent,
  ArcListAttribute,
  ArcListItemAttribute,
  LengthMetrics
} from '@kit.ArkUI';
import { AppColors, AppDimensions, AppTypography } from '../common/Theme';

@Builder
function lastHeader() {
  Text('Last Matches')
    .fontSize(AppTypography.TITLE_SMALL)
    .fontWeight(FontWeight.Bolder)
    .fontColor(AppColors.TEXT_PRIMARY)
}

@Component
export struct LastWeekPage {
  @Prop fixtures: FixtureListItem[] = [];
  @Prop isLoading: boolean = false;
  @Prop error: string = '';
  onSelectFixture: (fixtureId: number) => void = () => {
  };
  comCont = new ComponentContent(this.getUIContext(), wrapBuilder(lastHeader));

  build() {
    Column() {
      ArcList({ header: this.comCont }) {
        ForEach(this.fixtures, (fx: FixtureListItem) => {
          ArcListItem() {
            LastWeekItem({
              fx: fx,
              onItemClick: () => this.onSelectFixture(fx.fixture.id)
            })
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
struct LastWeekItem {
  @Prop fx: FixtureListItem;
  onItemClick: () => void = () => {
  };
  @State private homeCode: string = '';
  @State private awayCode: string = '';

  aboutToAppear(): void {
    this.homeCode = getTeamCodeFromName(this.fx.teams.home.name);
    this.awayCode = getTeamCodeFromName(this.fx.teams.away.name);
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

      Text(`${safeNumToText(this.fx.goals.home)}  -  ${safeNumToText(this.fx.goals.away)}`)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppColors.TEXT_PRIMARY)

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
    .onClick(() => this.onItemClick())
  }
}
