import { AppColors, AppDimensions, AppSpacing, AppTypography } from '../../common/Theme';
import { Event, LiveMatchUIModel } from '../../models/fixtures/FixturesApiTypes';
import { LiveMatchViewModel } from '../../viewmodels/LiveMatchViewModel';
import {
  ArcList,
  ArcListItem,
  ComponentContent,
  ArcListAttribute,
  ArcListItemAttribute,
  LengthMetrics,
  ArcSwiper,
  ArcSwiperAttribute
} from '@kit.ArkUI';

@Builder
function eventsHeader() {
  Text('Match Events')
    .fontSize(AppTypography.TITLE_SMALL)
    .fontWeight(FontWeight.Bolder)
    .fontColor(AppColors.TEXT_PRIMARY)
}

@Component
export struct LivePage {
  private timerId: number | null = null;
  @State vm: LiveMatchViewModel = new LiveMatchViewModel()
  @State liveMatch: LiveMatchUIModel | null = null
  comCont = new ComponentContent(this.getUIContext(), wrapBuilder(eventsHeader))
  @State myScale: number = 1.0;
  @State animVisible: boolean = false;
  uiContext: UIContext | undefined = undefined;
  @State start: boolean = false;
  @State animIcon: Resource | string = '';

  startScaleAnimation() {
    if (!this.uiContext) {
      console.info('no uiContext, keyframe failed');
      return;
    }
    this.myScale = 1;
    this.uiContext.animateTo({ duration: 3000, curve: Curve.Linear }, () => {
      this.start = !this.start;
    });
    this.uiContext.keyframeAnimateTo({
      iterations: 3,
      expectedFrameRateRange: {
        min: 10,
        max: 120,
        expected: 60
      },
      onFinish: () => {
        this.animVisible = false
      }
    }, [
      {
        duration: 700,
        event: () => {
          this.myScale = 1.5;
        }
      },
      {
        duration: 400,
        event: () => {
          this.myScale = 1;
        }
      }
    ]);
  }

  async aboutToAppear() {
    this.uiContext = this.getUIContext();
    const ok = this.vm.init()
    if (!ok) {
      return
    }
    await this.vm.loadAll();
    this.liveMatch = this.vm.liveMatch

    // Refresh every 30 seconds
    this.timerId = setInterval(async () => {
      await this.vm.loadAll();
      this.liveMatch = this.vm.liveMatch
    }, 30000);

    if (this.vm.newEventIndex) {
      const newEvent = this.liveMatch?.events[this.vm.newEventIndex]
      if (newEvent?.type === 'Goal') {
        this.animIcon = $r('app.media.football')
      } else if (newEvent?.detail === 'Yellow Card') {
        this.animIcon = $r('app.media.yellow_card')
      } else if (newEvent?.detail === 'Red card') {
        this.animIcon = $r('app.media.red_card')
      } else if (newEvent?.type === 'Var') {
        this.animIcon = $r('app.media.whistle')
      }
      this.startScaleAnimation()
      this.animVisible = true
      this.vm.newEventIndex = null
    }
  }

  build() {
    Stack() {
      if (this.vm.isLoading) {
        LoadingProgress()
          .width(AppDimensions.LOADING_SIZE)
          .height(AppDimensions.LOADING_SIZE)
          .zIndex(AppSpacing.XS)
      } else if (this.vm.errorMsg) {
        Text(this.vm.errorMsg)
      } else if (this.vm.liveMatch === null) {
        Text('Not Responded')
      } else {
        ArcSwiper() {
          Column() {
            Text('Match Statistics')
              .fontSize(AppTypography.TITLE_MEDIUM)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
              .margin({ top: AppSpacing.XL, bottom: AppSpacing.XS })

            Row({ space: 8 }) {
              Column() {
                Text(this.liveMatch?.homeTeamName)
                  .fontSize(10)
                  .fontWeight(FontWeight.Bold)
                  .maxLines(2)
                Blank()
                if (this.liveMatch?.homeTeamLogo !== '') {
                  Image(this.liveMatch?.homeTeamLogo)
                    .width(22)
                    .height(22)
                    .borderRadius(6)
                }
              }.width('36%')
              .height('100%')

              Column() {
                Row() {
                  Text(`${this.liveMatch?.homeTeamGoals}`)
                    .fontSize(16)

                  Text(`-`)
                    .fontSize(12)

                  Text(`${this.liveMatch?.awayTeamGoals}`)
                    .fontSize(16)
                }

                Text(`${this.liveMatch?.elapsed}'`)
                  .fontSize(10)
                  .margin({ top: 6 })
              }.width('28%')

              Column() {
                Text(this.liveMatch?.awayTeamName)
                  .fontSize(10)
                  .fontWeight(FontWeight.Bold)
                  .maxLines(2)
                Blank()
                if (this.liveMatch?.awayTeamLogo !== '') {
                  Image(this.liveMatch?.awayTeamLogo)
                    .width(22)
                    .height(22)
                    .borderRadius(6)
                }
              }.width('36%')
              .height('100%')
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .padding(10)
            .backgroundColor(0x0e2a44)
            .borderRadius(16)
            .width('90%')
            .height('26%')
            .margin(10)

            if (this.liveMatch?.homeTeamGoals === 0 && this.liveMatch?.awayTeamGoals === 0) {
              Text('No goal yet')
                .fontSize(AppTypography.BODY_MEDIUM)
                .fontColor(Color.White)
                .textAlign(TextAlign.Center)
                .margin({ top: AppSpacing.MD })
            } else {
              List() {
                ForEach(this.liveMatch?.events, (event: Event) => {
                  if (event.type === 'Goal') {
                    ListItem() {
                      Row() {
                        Text(`${event.time.elapsed}'`)
                          .fontSize(12)

                        Image($r('app.media.football'))
                          .width(20)
                          .height(20)
                          .borderRadius(6)
                          .margin({ left: 10 })

                        Text(`${event.detail}`)
                          .fontSize(12)
                          .margin({ left: 10 })
                      }
                      .justifyContent(FlexAlign.Center)
                      .backgroundColor(0x0e2a44)
                      .borderRadius(16)
                      .padding(10)
                      .margin(2)
                      .width('90%')
                    }
                  }
                })
              }
              .width('100%')
              .height('50%')
              .scrollBar(BarState.Off)
              .alignListItem(ListItemAlign.Center)
            }

          }

          if (this.liveMatch?.events.length === 0) {
            Text('No event yet')
              .fontSize(AppTypography.BODY_MEDIUM)
              .fontColor(Color.White)
              .textAlign(TextAlign.Center)
          } else {
            Column() {
              ArcList({ header: this.comCont }) {
                ForEach(this.liveMatch?.events, (event: Event) => {
                  if (event.type !== 'Subst') {
                    ArcListItem() {
                      Row() {
                        Text(`${event.time.elapsed}'`)
                          .fontSize(12)

                        if (event.type === 'Goal') {
                          Image($r('app.media.football'))
                            .width(22)
                            .height(22)
                            .borderRadius(6)
                        } else if (event.detail === 'Yellow Card') {
                          Image($r('app.media.yellow_card'))
                            .width(22)
                            .height(22)
                            .borderRadius(6)
                        } else if (event.detail === 'Red card') {
                          Image($r('app.media.red_card'))
                            .width(22)
                            .height(22)
                            .borderRadius(6)
                        } else if (event.type === 'Var') {
                          Image($r('app.media.whistle'))
                            .width(22)
                            .height(22)
                            .borderRadius(6)
                        }

                        Text(`${event.detail}`)
                          .fontSize(12)

                        Text(`-`)
                          .fontSize(12)

                        Text(`${event.team.name}`)
                          .width('30%')
                          .fontSize(12)
                          .maxLines(2)
                      }
                      .justifyContent(FlexAlign.SpaceBetween)
                      .padding(10)
                      .backgroundColor(0x0e2a44)
                      .borderRadius(16)
                      .width('90%')
                      .margin(2)
                    }
                  }
                }, (it: Event) => it.time.elapsed.toString())
              }.scrollBar(BarState.Off)
              .width('100%')
              .height('100%')
            }.width('100%')
            .height('100%')
          }

        }.width('100%')
        .height('100%')
      }

      Row() {
        Image(this.animIcon)
          .width(50)
          .scale({ x: this.myScale, y: this.myScale })
          .motionPath({
            path: 'M180 450 L180 200',
            from: 0.0,
            to: 1.0,
            rotatable: false
          })
          .visibility(this.animVisible ? Visibility.Visible : Visibility.Hidden)
      }
      .width('100%')
      .height('100%')
      .alignItems(this.start ? VerticalAlign.Bottom : VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .enabled(this.animVisible)

    }.width('100%')
    .height('100%')
    .alignContent(Alignment.Center)
    .backgroundColor(AppColors.BACKGROUND_PRIMARY)
  }
}