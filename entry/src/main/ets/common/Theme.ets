/**
 * Sports Authentication App Theme
 * HarmonyOS NEXT Theme Configuration
 * Dark theme with green accent inspired by sports tracking app
 */

export class AppColors {
  // Background Colors
  static readonly BACKGROUND_PRIMARY: ResourceColor = $r('app.color.background_primary');
  static readonly BACKGROUND_SECONDARY: ResourceColor = $r('app.color.background_secondary');
  static readonly BACKGROUND_TERTIARY: ResourceColor = $r('app.color.background_tertiary');

  // Surface Colors
  static readonly SURFACE_CARD: ResourceColor = $r('app.color.surface_card');
  static readonly SURFACE_INPUT: ResourceColor = $r('app.color.surface_input');
  static readonly SURFACE_ELEVATED: ResourceColor = $r('app.color.surface_elevated');

  // Primary Colors (Green)
  static readonly PRIMARY: ResourceColor = $r('app.color.primary');
  static readonly PRIMARY_VARIANT: ResourceColor = $r('app.color.primary_variant');
  static readonly PRIMARY_DARK: ResourceColor = $r('app.color.primary_dark');
  static readonly PRIMARY_CONTAINER: ResourceColor = $r('app.color.primary_container');
  static readonly ON_PRIMARY: ResourceColor = $r('app.color.on_primary');

  // Accent Colors (Red - Logo)
  static readonly ACCENT_RED: ResourceColor = $r('app.color.accent_red');
  static readonly ACCENT_RED_CONTAINER: ResourceColor = $r('app.color.accent_red_container');
  static readonly ON_ACCENT_RED: ResourceColor = $r('app.color.on_accent_red');

  // Text Colors
  static readonly TEXT_PRIMARY: ResourceColor = $r('app.color.text_primary');
  static readonly TEXT_SECONDARY: ResourceColor = $r('app.color.text_secondary');
  static readonly TEXT_TERTIARY: ResourceColor = $r('app.color.text_tertiary');
  static readonly TEXT_HINT: ResourceColor = $r('app.color.text_hint');
  static readonly TEXT_DISABLED: ResourceColor = $r('app.color.text_disabled');
  static readonly TEXT_LINK: ResourceColor = $r('app.color.text_link');

  // Icon Colors
  static readonly ICON_PRIMARY: ResourceColor = $r('app.color.icon_primary');
  static readonly ICON_SECONDARY: ResourceColor = $r('app.color.icon_secondary');
  static readonly ICON_TERTIARY: ResourceColor = $r('app.color.icon_tertiary');

  // Border Colors
  static readonly BORDER_DEFAULT: ResourceColor = $r('app.color.border_default');
  static readonly BORDER_FOCUS: ResourceColor = $r('app.color.border_focus');
  static readonly BORDER_ERROR: ResourceColor = $r('app.color.border_error');
  static readonly DIVIDER: ResourceColor = $r('app.color.divider');

  // Semantic Colors
  static readonly ERROR: ResourceColor = $r('app.color.error');
  static readonly WARNING: ResourceColor = $r('app.color.warning');
  static readonly SUCCESS: ResourceColor = $r('app.color.success');
  static readonly INFO: ResourceColor = $r('app.color.info');

  // Overlay & Effects
  static readonly OVERLAY: ResourceColor = $r('app.color.overlay');
  static readonly OVERLAY_OPACITY: ResourceColor = $r('app.color.overlay_opacity');
  static readonly RIPPLE: ResourceColor = $r('app.color.ripple');
  static readonly SHADOW: ResourceColor = $r('app.color.shadow');

  static readonly CARD_BG: ResourceColor = $r('app.color.card_list_item_bg');
}

export class AppTypography {
  // Display
  static readonly DISPLAY_LARGE: number = 32;
  static readonly DISPLAY_MEDIUM: number = 28;
  static readonly DISPLAY_SMALL: number = 24;

  // Headline
  static readonly HEADLINE_LARGE: number = 24;
  static readonly HEADLINE_MEDIUM: number = 20;
  static readonly HEADLINE_SMALL: number = 18;

  // Title
  static readonly TITLE_LARGE: number = 18;
  static readonly TITLE_MEDIUM: number = 16;
  static readonly TITLE_SMALL: number = 14;

  // Body
  static readonly BODY_LARGE: number = 16;
  static readonly BODY_MEDIUM: number = 14;
  static readonly BODY_SMALL: number = 12;
  static readonly BODY_X_SMALL: number = 10;

  // Label
  static readonly LABEL_LARGE: number = 14;
  static readonly LABEL_MEDIUM: number = 12;
  static readonly LABEL_SMALL: number = 10;

  // Font Weights
  static readonly WEIGHT_REGULAR: FontWeight = FontWeight.Regular;
  static readonly WEIGHT_MEDIUM: FontWeight = FontWeight.Medium;
  static readonly WEIGHT_SEMIBOLD: FontWeight = 600;
  static readonly WEIGHT_BOLD: FontWeight = FontWeight.Bold;
}

export class AppSpacing {
  static readonly NONE: number = 0;
  static readonly XXS: number = 2;
  static readonly XS: number = 4;
  static readonly SM: number = 8;
  static readonly SMD: number = 10;
  static readonly MD: number = 12;
  static readonly LG: number = 16;
  static readonly XL: number = 20;
  static readonly XXL: number = 24;
  static readonly XXXL: number = 32;
  static readonly HUGE: number = 40;
  static readonly MASSIVE: number = 48;

  // Page Margins
  static readonly PAGE_HORIZONTAL: number = 20;
  static readonly PAGE_VERTICAL: number = 16;

  // Card Padding
  static readonly CARD_PADDING: number = 16;

  // Input Padding
  static readonly INPUT_HORIZONTAL: number = 16;
  static readonly INPUT_VERTICAL: number = 14;

  static readonly HEADER_MARGIN: number = 6;
  static readonly TEN_GAP: number = 10;
  static readonly ITEM_BOTTOM_MARGIN: number = 10;
}

export class AppRadius {
  static readonly NONE: number = 0;
  static readonly XS: number = 4;
  static readonly SM: number = 8;
  static readonly MD: number = 12;
  static readonly LG: number = 16;
  static readonly XL: number = 20;
  static readonly XXL: number = 24;
  static readonly ROUND: number = 9999;

  // Component Specific
  static readonly BUTTON: number = 12;
  static readonly INPUT: number = 12;
  static readonly CARD: number = 16;
  static readonly TAB: number = 8;
  static readonly LOGO: number = 16;
  static readonly SOCIAL_BUTTON: number = 12;
}

export class AppElevation {
  static readonly NONE: ShadowOptions = {
    radius: 0,
    color: 'transparent',
    offsetX: 0,
    offsetY: 0
  };

  static readonly LOW: ShadowOptions = {
    radius: 4,
    color: '#20000000',
    offsetX: 0,
    offsetY: 2
  };

  static readonly MEDIUM: ShadowOptions = {
    radius: 8,
    color: '#30000000',
    offsetX: 0,
    offsetY: 4
  };

  static readonly HIGH: ShadowOptions = {
    radius: 16,
    color: '#40000000',
    offsetX: 0,
    offsetY: 8
  };
}

export class AppDimensions {
  // Layout Heights
  static readonly FULL_SIZE: string = '100%';

  // Button Heights
  static readonly BUTTON_HEIGHT_SM: number = 36;
  static readonly BUTTON_HEIGHT_MD: number = 44;
  static readonly BUTTON_HEIGHT_LG: number = 52;

  // Input Heights
  static readonly INPUT_HEIGHT: number = 52;

  // Icon Sizes
  static readonly ICON_XS: number = 16;
  static readonly ICON_SM: number = 20;
  static readonly ICON_MD: number = 24;
  static readonly ICON_LG: number = 32;
  static readonly ICON_XL: number = 40;
  static readonly ICON_XXL: number = 180;

  // Logo Sizes
  static readonly LOGO_SM: number = 48;
  static readonly LOGO_MD: number = 64;
  static readonly LOGO_LG: number = 80;

  // Tab Dimensions
  static readonly TAB_HEIGHT: number = 40;
  static readonly TAB_MIN_WIDTH: number = 80;

  // Social Button
  static readonly SOCIAL_BUTTON_HEIGHT: number = 48;
  static readonly SOCIAL_BUTTON_ICON: number = 20;

  // Navigation
  static readonly NAV_BAR_HEIGHT: number = 56;
  static readonly BACK_BUTTON_SIZE: number = 40;

  static readonly ITEM_WIDTH_PERCENT: string = '90%';
  static readonly ITEM_ICON_SIZE: number = 20;
  static readonly LOADING_SIZE: number = 60;
  static readonly BORDER_HAIRLINE: number = 0.5;
}

export class AppAnimation {
  static readonly DURATION_FAST: number = 150;
  static readonly DURATION_NORMAL: number = 250;
  static readonly DURATION_SLOW: number = 350;

  static readonly CURVE_EASE: Curve = Curve.EaseInOut;
  static readonly CURVE_BOUNCE: Curve = Curve.FastOutSlowIn;
}

export class ButtonStyles {
  static primaryStyle(): ButtonStyleOptions {
    return {
      backgroundColor: AppColors.PRIMARY,
      fontColor: AppColors.ON_PRIMARY,
      fontSize: AppTypography.BODY_LARGE,
      fontWeight: AppTypography.WEIGHT_SEMIBOLD,
      borderRadius: AppRadius.BUTTON,
      height: AppDimensions.BUTTON_HEIGHT_LG
    };
  }

  static secondaryStyle(): ButtonStyleOptions {
    return {
      backgroundColor: AppColors.SURFACE_CARD,
      fontColor: AppColors.TEXT_PRIMARY,
      fontSize: AppTypography.BODY_MEDIUM,
      fontWeight: AppTypography.WEIGHT_MEDIUM,
      borderRadius: AppRadius.BUTTON,
      height: AppDimensions.BUTTON_HEIGHT_MD,
      borderWidth: 1,
      borderColor: AppColors.BORDER_DEFAULT
    };
  }

  static socialStyle(): ButtonStyleOptions {
    return {
      backgroundColor: AppColors.SURFACE_CARD,
      fontColor: AppColors.TEXT_PRIMARY,
      fontSize: AppTypography.BODY_MEDIUM,
      fontWeight: AppTypography.WEIGHT_MEDIUM,
      borderRadius: AppRadius.SOCIAL_BUTTON,
      height: AppDimensions.SOCIAL_BUTTON_HEIGHT,
      borderWidth: 1,
      borderColor: AppColors.BORDER_DEFAULT
    };
  }
}

export class InputStyles {
  static defaultStyle(): TextInputStyleOptions {
    return {
      backgroundColor: AppColors.SURFACE_INPUT,
      fontColor: AppColors.TEXT_PRIMARY,
      placeholderColor: AppColors.TEXT_HINT,
      fontSize: AppTypography.BODY_MEDIUM,
      borderRadius: AppRadius.INPUT,
      height: AppDimensions.INPUT_HEIGHT,
      paddingLeft: AppSpacing.INPUT_HORIZONTAL,
      paddingRight: AppSpacing.INPUT_HORIZONTAL
    };
  }
}

interface ButtonStyleOptions {
  backgroundColor: ResourceColor;
  fontColor: ResourceColor;
  fontSize: number;
  fontWeight: FontWeight | number;
  borderRadius: number;
  height: number;
  borderWidth?: number;
  borderColor?: ResourceColor;
}

interface TextInputStyleOptions {
  backgroundColor: ResourceColor;
  fontColor: ResourceColor;
  placeholderColor: ResourceColor;
  fontSize: number;
  borderRadius: number;
  height: number;
  paddingLeft: number;
  paddingRight: number;
}