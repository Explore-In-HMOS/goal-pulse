import { AppColors } from '../common/Theme';

@Component
export struct MatchesInfoPage {
  onItemClick: (index: number) => void = () => {
  }

  build() {
    Column({ space: 10 }) {
      MatchInfoText({
        text: '1. Last Matches',
        onItemClick: () => {
          this.onItemClick(1)
        }
      })
      MatchInfoText({
        text: '2. League Table', onItemClick: () => {
          this.onItemClick(2)
        }
      })
      MatchInfoText({
        text: '3. Next Matches', onItemClick: () => {
          this.onItemClick(3)
        }
      })
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BACKGROUND_PRIMARY)
  }
}

@Component
export struct MatchInfoText {
  @Prop text: string
  onItemClick: () => void = () => {
  }

  build() {
    Column() {
      Text(this.text)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor(AppColors.TEXT_PRIMARY)
        .padding(13)
    }
    .backgroundColor(0x0e2a44)
    .borderRadius(16)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .onClick(() => this.onItemClick())
  }
}
