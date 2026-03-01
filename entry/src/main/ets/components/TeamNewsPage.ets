import { AppColors, AppTypography } from '../common/Theme';
import {
  ArcList,
  ArcListItem,
  ComponentContent,
  ArcListAttribute,
  ArcListItemAttribute,
  LengthMetrics
} from '@kit.ArkUI';
import { NewsCardModel } from '../models/news/NewsApiTypes';

@Builder
function newsHeader() {
  Text('News')
    .fontSize(AppTypography.TITLE_SMALL)
    .fontWeight(FontWeight.Bolder)
    .fontColor(AppColors.TEXT_PRIMARY)
}

@Component
export struct TeamNewsPage {
  @Prop news: NewsCardModel[] = [];
  @Prop hasMore: boolean;
  @Prop isLoading: boolean;
  onItemClicked: () => void = () => {
  };
  comCont = new ComponentContent(this.getUIContext(), wrapBuilder(newsHeader));
  @State private keepIndex: number = 0;

  build() {
    Column() {
      if (this.news.length > 0) {
        ArcList({ header: this.comCont, initialIndex: this.keepIndex }) {
          ForEach(this.news, (it: NewsCardModel) => {
            ArcListItem() {
              Column({ space: 6 }) {
                Row({ space: 6 }) {
                  if (it.imageUrl) {
                    Image(it.imageUrl)
                      .width(45)
                      .height(45)
                      .objectFit(ImageFit.Cover)
                      .borderRadius(8)
                  } else {
                    Column()
                      .width(45)
                      .height(45)
                      .backgroundColor(0x1e3a5f)
                      .borderRadius(8)
                  }

                  Text(it.title)
                    .fontSize(11)
                    .maxLines(3)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .textAlign(TextAlign.Start)
                    .layoutWeight(1)
                }
                .width('100%')

                if (it.description.length > 0) {
                  Text(it.description)
                    .fontSize(11)
                    .opacity(0.85)
                    .maxLines(3)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                Text(it.subtitle)
                  .fontSize(9)
                  .opacity(0.6)
              }
              .padding(6)
              .backgroundColor(0x0e2a44)
              .borderRadius(12)
            }
            .width('80%')
          }, (it: NewsCardModel) => it.link)

          if (this.hasMore) {
            ArcListItem() {
              Column() {
                if (this.isLoading) {
                  LoadingProgress().width(24).height(24)
                } else {
                  Text('Load More')
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .onClick(() => {
                      const safe = Math.max(0, this.news.length - 3);
                      this.keepIndex = safe;

                      this.onItemClicked();
                    })
                }
              }
              .padding(6)
              .alignItems(HorizontalAlign.Center)
            }
            .width('80%')
          }
        }
        .scrollBar(BarState.Off)
        .width('100%')
      } else {
        Column() {
          Text('No news about this team')
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
        }
        .width('100%')
        .height('100%')
        .padding(6)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
    }
    .backgroundColor(AppColors.BACKGROUND_PRIMARY)
    .width('100%')
    .height('100%')
  }
}
