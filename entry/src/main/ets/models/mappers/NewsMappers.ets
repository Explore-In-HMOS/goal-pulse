import { NewsArticle, NewsCardModel } from '../news/NewsApiTypes';

export function toNewsCardModel(a: NewsArticle): NewsCardModel {
  const source = a.sourceName ?? a.sourceId ?? '';
  const date = a.pubDate ?? '';

  return {
    id: a.articleId ?? a.link,
    title: a.title ?? '',
    subtitle: date ? `${source} • ${date}` : source,
    description: (a.description ?? '').trim(),
    imageUrl: a.imageUrl ?? undefined,
    link: a.link ?? '',
    isDuplicate: !!a.duplicate,
    categories: a.category ?? []
  };
}