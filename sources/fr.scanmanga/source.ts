import {
  Chapter,
  Manga,
  MangaPlugin,
  Page,
  Plugin,
  SourceInfo,
} from '@paperback/types';

export const ScanMangaInfo: SourceInfo = {
  version: '1.0.0',
  name: 'ScanManga',
  icon: 'icon.png',
  author: 'Destynovalee',
  lang: 'fr',
  description: 'Extension non officielle pour Scan-Manga.com',
  websiteBaseURL: 'https://www.scan-manga.com',
};

export class ScanManga extends MangaPlugin {
  async getMangaDetails(mangaId: string): Promise<Manga> {
    return {
      id: mangaId,
      title: 'Manga Factice',
      author: 'Auteur Inconnu',
      description: 'Description factice.',
      status: 1,
      image: '',
      views: 0,
      follows: 0,
      rating: 0,
      language: 'fr'
    };
  }

  async getChapters(mangaId: string): Promise<Chapter[]> {
    return [{
      id: 'ch1',
      title: 'Chapitre 1',
      langCode: 'fr',
      mangaId: mangaId,
      chapNum: 1,
      volume: 1,
      group: 'Groupe',
      time: new Date()
    }];
  }

  async getChapterPages(chapterId: string): Promise<Page[]> {
    return [{
      url: 'https://via.placeholder.com/800x1200.png?text=Page+1',
      index: 0
    }];
  }

  async search(query: string): Promise<Manga[]> {
    return [{
      id: 'manga1',
      title: 'Résultat Factice',
      image: '',
      subtitle: 'Aucun',
      language: 'fr'
    }];
  }
}
