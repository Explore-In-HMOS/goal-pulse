import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute, ComponentContent } from '@kit.ArkUI';
import { AppColors, AppDimensions, AppRadius, AppSpacing, AppTypography } from '../common/Theme';
import { Country } from '../models/country/Country';
import { Mode } from '../models/enums/EnumMode';
import { League } from '../models/league/LeaguesApiTypes';
import { Team, TeamUIModel } from '../models/teams/TeamsApiTypes';
import { OnboardingViewModel } from '../viewmodels/OnboardingViewModel';

@Builder
function countryHeader() {
  Column() {
    Text('Choose Country')
      .fontSize(AppTypography.HEADLINE_MEDIUM)
      .fontWeight(FontWeight.Bolder)
      .fontColor(AppColors.TEXT_PRIMARY)
  }.margin(AppSpacing.HEADER_MARGIN)
}

@Builder
function leagueHeader() {
  Column() {
    Text('Choose League')
      .fontSize(AppTypography.HEADLINE_MEDIUM)
      .fontWeight(FontWeight.Bolder)
      .fontColor(AppColors.TEXT_PRIMARY)
  }.margin(AppSpacing.HEADER_MARGIN)
}

@Builder
function teamHeader() {
  Column() {
    Text('Choose Team')
      .fontSize(AppTypography.HEADLINE_MEDIUM)
      .fontWeight(FontWeight.Bolder)
      .fontColor(AppColors.TEXT_PRIMARY)
  }.margin(AppSpacing.HEADER_MARGIN)
}

@Component
export struct UniversalList {
  @ObjectLink vm: OnboardingViewModel;
  private context: UIContext = this.getUIContext();
  @Watch('onResetTokenChanged') @Prop resetToken: number = 0;
  private scroller: Scroller = new Scroller();

  private onResetTokenChanged() {
    try {
      this.scroller.scrollToIndex(0);
    } catch (e) {
      this.scroller.scrollTo({ xOffset: 0, yOffset: 0, animation: true });
    }
  }

  private getHeader(): ComponentContent<Object> {
    if (this.vm.mode === Mode.Country) {
      return new ComponentContent(this.context, wrapBuilder(countryHeader));
    }
    if (this.vm.mode === Mode.League) {
      return new ComponentContent(this.context, wrapBuilder(leagueHeader));
    }
    return new ComponentContent(this.context, wrapBuilder(teamHeader));
  }

  build() {
    Stack() {
      LoadingProgress()
        .width(AppDimensions.LOADING_SIZE)
        .height(AppDimensions.LOADING_SIZE)
        .zIndex(AppSpacing.XS)
        .enableLoading(this.vm.isLoading)
      ArcList({ initialIndex: 0, header: this.getHeader(), scroller: this.scroller }) {
        if (this.vm.mode === Mode.Country) {
          ForEach(this.vm.countries, (item: Country) => {
            ArcListItem() {
              Row({ space: AppSpacing.TEN_GAP }) {
                Image(item.flag).width(AppDimensions.ITEM_ICON_SIZE)
                  .height(AppDimensions.ITEM_ICON_SIZE)
                Text(item.name)
                  .fontSize(AppTypography.BODY_SMALL)
                  .fontColor(AppColors.TEXT_SECONDARY)
                  .fontWeight(FontWeight.Bold)
                  .width(AppDimensions.ITEM_WIDTH_PERCENT)
                  .textAlign(TextAlign.Start)
              }
              .padding(AppSpacing.MD)
              .backgroundColor(AppColors.SURFACE_INPUT)
              .width(AppDimensions.ITEM_WIDTH_PERCENT)
              .borderRadius(AppRadius.XXL)
              .borderWidth(AppDimensions.BORDER_HAIRLINE)
              .borderColor(AppColors.BORDER_DEFAULT)
            }
            .onClick(() => this.vm.selectCountry(item.code))
            .width(AppDimensions.ITEM_WIDTH_PERCENT)
            .margin({ bottom: AppSpacing.TEN_GAP })
          }, (item: Country) => item.code)
        }
        if (this.vm.mode === Mode.League) {
          ForEach(this.vm.leagues, (item: League) => {
            ArcListItem() {
              Row({ space: AppSpacing.TEN_GAP }) {
                Image(item.logo)
                  .width(AppDimensions.ITEM_ICON_SIZE)
                  .height(AppDimensions.ITEM_ICON_SIZE)
                Text(item.name)
                  .fontSize(AppTypography.BODY_SMALL)
                  .fontColor(AppColors.TEXT_SECONDARY)
                  .fontWeight(FontWeight.Bold)
                  .width(AppDimensions.ITEM_WIDTH_PERCENT)
                  .textAlign(TextAlign.Start)
              }
              .padding(AppSpacing.MD)
              .backgroundColor(AppColors.SURFACE_INPUT)
              .width(AppDimensions.ITEM_WIDTH_PERCENT)
              .borderRadius(AppRadius.XXL)
              .borderWidth(AppDimensions.BORDER_HAIRLINE)
              .borderColor(AppColors.BORDER_DEFAULT)
            }
            .onClick(() => this.vm.selectLeagueAndPersist(item))
            .width(AppDimensions.ITEM_WIDTH_PERCENT)
            .margin({ bottom: AppSpacing.TEN_GAP })
          }, (item: League) => item.id.toString())
        }
        if (this.vm.mode === Mode.Team) {
          ForEach(this.vm.teams, (item: TeamUIModel) => {
            ArcListItem() {
              Row({ space: AppSpacing.TEN_GAP }) {
                if (item.logo) {
                  Image(item.logo).width(AppDimensions.ITEM_ICON_SIZE)
                    .height(AppDimensions.ITEM_ICON_SIZE)
                }
                Text(item.name)
                  .fontSize(AppTypography.BODY_SMALL)
                  .fontColor(AppColors.TEXT_SECONDARY)
                  .fontWeight(FontWeight.Bold)
                  .width(AppDimensions.ITEM_WIDTH_PERCENT)
                  .textAlign(TextAlign.Start)
              }
              .padding(AppSpacing.MD)
              .backgroundColor(AppColors.SURFACE_INPUT)
              .width(AppDimensions.ITEM_WIDTH_PERCENT)
              .borderRadius(AppRadius.XXL)
              .borderWidth(AppDimensions.BORDER_HAIRLINE)
              .borderColor(AppColors.BORDER_DEFAULT)
            }
            .onClick(() => this.vm.selectTeam(item))
            .width(AppDimensions.ITEM_WIDTH_PERCENT)
            .margin({ bottom: AppSpacing.TEN_GAP })
          }, (item: Team) => item.id.toString())
        }
      }
      .visibility(this.vm.isLoading ? Visibility.Hidden : Visibility.Visible)
      .scrollBar(BarState.Off)
      .zIndex(AppSpacing.XS)
      .padding({ top: AppSpacing.SM, bottom: AppSpacing.SM })
      .height(AppDimensions.FULL_SIZE)
      .width(AppDimensions.FULL_SIZE)
      .backgroundColor(AppColors.BACKGROUND_PRIMARY)
    }
  }
}