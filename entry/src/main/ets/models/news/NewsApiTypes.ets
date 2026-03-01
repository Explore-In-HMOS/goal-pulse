export interface NewsLatestResponse {
  status: 'success' | 'error' | string;
  totalResults: number;
  results: NewsArticle[];
  nextPage?: string;
}

export interface NewsArticle {
  articleId: string;
  link: string;
  title: string;

  description?: string | null;
  content?: string | null;

  keywords?: string[] | null;
  creator?: string[] | null;

  language?: string | null;
  country?: string[] | null;
  category?: string[] | null;

  datatype?: 'news' | 'opinion' | string;

  pubDate?: string | null;
  pubDateTZ?: string | null;
  fetchedAt?: string | null;

  imageUrl?: string | null;
  videoUrl?: string | null;

  sourceId?: string | null;
  sourceName?: string | null;
  sourcePriority?: number | null;
  sourceUrl?: string | null;
  sourceIcon?: string | null;

  duplicate?: boolean | null;
}

export interface NewsCardModel {
  id: string;
  title: string;
  subtitle: string;
  description: string;
  imageUrl?: string;
  link: string;
  isDuplicate: boolean;
  categories: string[];
}
